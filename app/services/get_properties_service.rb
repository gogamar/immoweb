require 'nokogiri'
require 'net/ftp'
require 'open-uri'
require 'fileutils'

class GetPropertiesService
  include ActionView::Helpers::NumberHelper

  FTP_HOST = 'ftp.ghestia.cat'
  XML_FOLDER = Rails.root.join('public', 'xml')
  MAIN_XML_FILE = 'INMUEBLES_MODIFICADOS.xml'
  BATCH_SIZE = 100
  MAX_RETRIES = 3
  RETRY_DELAY = 2

  class ServiceError < StandardError; end
  class FTPError < ServiceError; end
  class XMLParsingError < ServiceError; end

  def initialize
    @logger = Rails.logger
    @stats = { processed: 0, created: 0, updated: 0, deactivated: 0, errors: 0, images_processed: 0 }
  end

  def call
    @logger.info "Starting property synchronization from #{FTP_HOST}"
    start_time = Time.current

    begin
      ensure_xml_folder_exists
      download_xml_files
      sync_properties
      cleanup_old_files

      log_completion_stats(start_time)
      @stats
    rescue => e
      @logger.error "Property sync failed: #{e.message}"
      @logger.error e.backtrace.join("\n")
      raise ServiceError, "Property synchronization failed: #{e.message}"
    end
  end

  private

  def ensure_xml_folder_exists
    FileUtils.mkdir_p(XML_FOLDER) unless Dir.exist?(XML_FOLDER)
  end

  def download_xml_files
    @logger.info "Downloading XML files from FTP server"

    with_ftp_connection do |ftp|
      xml_files = ftp.nlst.select { |f| File.extname(f).casecmp('.xml').zero? }
      @logger.info "Found #{xml_files.size} XML files to download"

      xml_files.each do |filename|
        download_file_with_retry(ftp, filename)
      end
    end
  end

  def with_ftp_connection
    ftp = Net::FTP.new(FTP_HOST)
    ftp.login(ENV['GH_L'], ENV['GH_P'])
    ftp.passive = true # More reliable for firewalls

    yield ftp
  rescue Net::FTPError => e
    raise FTPError, "FTP connection failed: #{e.message}"
  ensure
    ftp&.close
  end

  def download_file_with_retry(ftp, filename)
    local_path = XML_FOLDER.join(filename)
    retries = 0

    begin
      ftp.getbinaryfile(filename, local_path.to_s)
      @logger.debug "Downloaded #{filename}"
    rescue Net::FTPError => e
      retries += 1
      if retries <= MAX_RETRIES
        @logger.warn "Download failed for #{filename}, retry #{retries}/#{MAX_RETRIES}: #{e.message}"
        sleep(RETRY_DELAY * retries)
        retry
      else
        raise FTPError, "Failed to download #{filename} after #{MAX_RETRIES} retries"
      end
    end
  end

  def sync_properties
    xml_file_path = XML_FOLDER.join(MAIN_XML_FILE)

    unless File.exist?(xml_file_path)
      raise XMLParsingError, "Main XML file #{MAIN_XML_FILE} not found"
    end

    @logger.info "Parsing XML file: #{xml_file_path}"

    begin
      doc = Nokogiri::XML(File.read(xml_file_path)) do |config|
        config.strict.nonet
      end
    rescue Nokogiri::XML::SyntaxError => e
      raise XMLParsingError, "Invalid XML format: #{e.message}"
    end

    process_listings(doc)
    deactivate_missing_listings
  end

  def process_listings(doc)
    listings = doc.search('inmueble')
    @logger.info "Processing #{listings.size} listings"

    @processed_ids = []

    listings.each_slice(BATCH_SIZE) do |batch|
      ActiveRecord::Base.transaction do
        batch.each { |listing_node| process_single_listing(listing_node) }
      end
    end
  end

  def process_single_listing(gh_listing)
    idfile = gh_listing.at('IdFicha')&.text&.strip

    unless idfile.present?
      @logger.warn "Skipping listing without IdFicha"
      @stats[:errors] += 1
      return
    end

    @processed_ids << idfile
    listing_attributes = build_listing_attributes(gh_listing)

    listing = Listing.find_or_initialize_by(idfile: idfile)
    is_new_record = listing.new_record?

    listing.assign_attributes(listing_attributes)
    listing.user ||= admin_user

    if listing.save
      process_images_for_listing(listing, gh_listing)

      if is_new_record
        @stats[:created] += 1
        @logger.debug "Created listing #{idfile}"
      else
        @stats[:updated] += 1
        @logger.debug "Updated listing #{idfile}"
      end
    else
      @logger.error "Failed to save listing #{idfile}: #{listing.errors.full_messages.join(', ')}"
      @stats[:errors] += 1
    end

    @stats[:processed] += 1
  rescue => e
    @logger.error "Error processing listing #{idfile}: #{e.message}"
    @stats[:errors] += 1
  end

  def build_listing_attributes(gh_listing)
    {
      status: safe_enum_lookup(gh_listing.at('Estado')&.text, Listing::LISTING_STATUS),
      listing_type: safe_enum_lookup(gh_listing.at('TipoGenerico')&.text, Listing::LISTING_TYPE),
      listing_subtype: safe_enum_lookup(gh_listing.at('TipoEspecifico')&.text, Listing::LISTING_SUBTYPE),
      ref_number: safe_text(gh_listing.at('Referencia')),
      idagency: safe_text(gh_listing.at('IdAgencia')),
      country: safe_text(gh_listing.at('Pais')),
      speclocation: safe_text(gh_listing.at('SituacionConcreta')),
      typestreet: safe_enum_lookup(gh_listing.at('TipoVia')&.text, Listing::TYPESTREET),
      namestreet: safe_text(gh_listing.at('NombreVia')),
      numberstreet: safe_text(gh_listing.at('NumeroVia')),
      usable_area: safe_numeric(gh_listing.at('SuperficieUtil')),
      built_area: safe_numeric(gh_listing.at('SuperficieConstruida')),
      operation: determine_operation(gh_listing),
      salesprice: safe_numeric(gh_listing.at('PrecioVenta')),
      rentprice: safe_numeric(gh_listing.at('PrecioAlquiler')),
      region: safe_text(gh_listing.at('Comunidad')),
      province: safe_text(gh_listing.at('Provincia')),
      town_name: safe_text(gh_listing.at('Localidad')),
      postcode: safe_text(gh_listing.at('CodigoPostal')),
      town_area: safe_text(gh_listing.at('Zona')),
      title_ca: safe_text(gh_listing.at('SloganCAT')) || safe_text(gh_listing.at('Slogan')),
      title_es: safe_text(gh_listing.at('Slogan')),
      description_ca: safe_text(gh_listing.at('AnuncioCAT')) || safe_text(gh_listing.at('Anuncio')),
      description_es: safe_text(gh_listing.at('Anuncio')),
      preservation: find_feature_value(gh_listing, 'Estado conservación', Listing::PRESERVATION),
      bedrooms: safe_numeric(find_feature_value(gh_listing, 'Nº de dormitorios')),
      bathrooms: safe_numeric(find_feature_value(gh_listing, 'Nº de baños')),
      energy_cert: find_feature_value(gh_listing, 'Categoría del consumo energético'),
      published_on: safe_date_parse(gh_listing.at('FechaAlta')&.text)
    }
  end

  def safe_text(node)
    node&.text&.strip.presence
  end

  def safe_numeric(node_or_value)
    value = node_or_value.is_a?(Nokogiri::XML::Node) ? node_or_value&.text : node_or_value
    return nil unless value.present?

    # Remove any non-numeric characters except decimal point
    cleaned = value.to_s.gsub(/[^\d.]/, '')
    cleaned.present? ? cleaned.to_f : nil
  end

  def safe_enum_lookup(value, enum_hash)
    return nil unless value.present? && enum_hash.is_a?(Hash)
    enum_hash[value.strip]
  end

  def safe_date_parse(date_string)
    return nil unless date_string.present?
    Date.parse(date_string.strip)
  rescue Date::Error => e
    @logger.warn "Invalid date format: #{date_string}"
    nil
  end

  def determine_operation(gh_listing)
    sale_price = safe_text(gh_listing.at('PrecioVenta'))
    rent_price = safe_text(gh_listing.at('PrecioAlquiler'))

    if sale_price.present? && rent_price.present?
      'both'
    elsif sale_price.present?
      'sale'
    elsif rent_price.present?
      'rent'
    else
      'unknown'
    end
  end

  def find_feature_value(gh_listing, description, mapping = nil)
    # Use more specific XPath to avoid false matches
    node = gh_listing.xpath(".//Caracteristica[Descripcion[text()='#{description}']]/Valor").first
    return nil unless node

    value = node.text.strip
    return nil unless value.present?

    mapping ? mapping[value] : value
  end

  def process_images_for_listing(listing, gh_listing)
    image_urls_from_xml = extract_image_urls(gh_listing)
    return if image_urls_from_xml.empty?

    @logger.debug "Processing #{image_urls_from_xml.size} images for listing #{listing.idfile}"

    # Remove image_urls no longer in the feed
    remove_outdated_image_urls(listing, image_urls_from_xml)

    # Create new image_url records for new URLs
    create_new_image_urls(listing, image_urls_from_xml)

    # Use ImageKit service to migrate images
    migrate_images_to_imagekit(listing)
  rescue => e
    @logger.error "Error processing images for listing #{listing.idfile}: #{e.message}"
  end

  def extract_image_urls(gh_listing)
    gh_listing.search('foto url').map(&:text).compact.map(&:strip).reject(&:blank?)
  end

  def remove_outdated_image_urls(listing, current_urls)
    # Remove image_url records that are no longer in the XML feed
    outdated_image_urls = listing.image_urls.where.not(url: current_urls)

    if outdated_image_urls.any?
      @logger.debug "Removing #{outdated_image_urls.count} outdated images for listing #{listing.idfile}"
      outdated_image_urls.destroy_all
    end
  end

  def create_new_image_urls(listing, image_urls_from_xml)
    existing_urls = listing.image_urls.pluck(:url)
    new_urls = image_urls_from_xml - existing_urls

    return if new_urls.empty?

    @logger.debug "Creating #{new_urls.size} new image_url records for listing #{listing.idfile}"

    new_image_urls = new_urls.map do |url|
      {
        url: url,
        listing_id: listing.id,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    # Bulk insert for efficiency
    listing.image_urls.insert_all(new_image_urls) if new_image_urls.any?
    @stats[:images_processed] += new_image_urls.size
  end

  def migrate_images_to_imagekit(listing)
    # Use the ImageKit service to migrate any images that aren't already on ImageKit
    imagekit_service = ImagekitService.new(listing)
    imagekit_service.migrate_images
  rescue => e
    @logger.error "Error migrating images to ImageKit for listing #{listing.idfile}: #{e.message}"
  end

  def deactivate_missing_listings
    return if @processed_ids.empty?

    deactivated_listings = Listing.where.not(idfile: @processed_ids)
    count = deactivated_listings.count

    if count > 0
      @logger.info "Deactivating #{count} listings no longer in feed"
      deactivated_listings.destroy_all
      @stats[:deactivated] = count
    end
  end

  def cleanup_old_files
    # Remove XML files older than 24 hours to save disk space
    old_files = Dir.glob(XML_FOLDER.join('*.xml')).select do |file|
      File.mtime(file) < 24.hours.ago
    end

    old_files.each { |file| File.delete(file) }
    @logger.info "Cleaned up #{old_files.size} old XML files" if old_files.any?
  end

  def admin_user
    @admin_user ||= User.find_by!(admin: true)
  end

  def log_completion_stats(start_time)
    duration = Time.current - start_time

    @logger.info <<~LOG
      Property synchronization completed in #{duration.round(2)} seconds
      - Processed: #{@stats[:processed]}
      - Created: #{@stats[:created]}
      - Updated: #{@stats[:updated]}
      - Deactivated: #{@stats[:deactivated]}
      - Images processed: #{@stats[:images_processed]}
      - Errors: #{@stats[:errors]}
    LOG
  end
end
