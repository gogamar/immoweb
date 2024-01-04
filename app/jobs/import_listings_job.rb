class ImportListingsJob < ApplicationJob
  queue_as :default
  require 'nokogiri'
  require 'net/ftp'

  def perform()
    ftp = Net::FTP.new('ftp.ghestia.cat')
    ftp.login(ENV['GH_L'], ENV['GH_P'])

    ftp.nlst.each do |filename|
      ftp.getbinaryfile(filename, "public/xml/#{filename}") if File.extname(filename) == '.xml'
    end

    doc = Nokogiri::XML(File.open("public/xml/INMUEBLES_MODIFICADOS.xml"))
    ghestia_listings = doc.search('inmueble')

    ghestia_listings.each do |gh_listing|
      idfile = gh_listing.search('IdFicha').first.content if gh_listing.search('IdFicha').first
      idagency = gh_listing.search('IdAgencia').first.content if gh_listing.search('IdAgencia').first.present?
      listing_type = gh_listing.search('TipoGenerico').first.content if gh_listing.search('TipoGenerico').first.present?
      ref_number = gh_listing.search('Referencia').first.content if gh_listing.search('Referencia').first.present?
      country = gh_listing.search('Pais').first.content if gh_listing.search('Pais').first.present?
      speclocation = gh_listing.search('SituacionConcreta').first.content if gh_listing.search('SituacionConcreta').first.present?
      typestreet = gh_listing.search('TipoVia').first.content if gh_listing.search('TipoVia').first.present?
      namestreet = gh_listing.search('NombreVia').first.content if gh_listing.search('NombreVia').first.present?
      numberstreet = gh_listing.search('NumeroVia').first.content if gh_listing.search('NumeroVia').first.present?
      usable_area = gh_listing.search('SuperficieUtil').first.content if gh_listing.search('SuperficieUtil').first.present?
      built_area = gh_listing.search('SuperficieConstruida').first.content if gh_listing.search('SuperficieConstruida').first.present?
      salesprice = gh_listing.search('PrecioVenta').first.content if gh_listing.search('PrecioVenta').first.present?
      rentprice = gh_listing.search('PrecioAlquiler').first.content if gh_listing.search('PrecioAlquiler').first.present?
      town_name = gh_listing.search('Localidad').first.content if gh_listing.search('Localidad').first.present?
      region = gh_listing.search('Comunidad').first.content if gh_listing.search('Comunidad').first.present?
      province = gh_listing.search('Provincia').first.content if gh_listing.search('Provincia').first.present?
      postcode = gh_listing.search('CodigoPostal').first.content if gh_listing.search('CodigoPostal').first.present?
      town_area = gh_listing.search('Zona').first.content if gh_listing.search('Zona').first.present?
      title_ca = gh_listing.search('SloganCAT').first.content if gh_listing.search('SloganCAT').first.present?
      title_es = gh_listing.search('Slogan').first.content if gh_listing.search('Slogan').first.present?
      description_ca = gh_listing.search('AnuncioCAT').first.content if gh_listing.search('AnuncioCAT').first.present?
      description_es = gh_listing.search('Anuncio').first.content if gh_listing.search('Anuncio').first.present?
      user_id = User.find_by(admin: true).id

      images = gh_listing.search('foto url').map(&:text)
      features = gh_listing.search("Caracteristica")

      local_listing = Listing.find_by(idfile: gh_listing.search('IdFicha').first.content)

      if local_listing.present?
        local_listing.update(idagency:, listing_type:, ref_number:, country:, speclocation:, typestreet:, namestreet:, numberstreet:, usable_area:, built_area:, salesprice:, rentprice:, region:, province:, town_name:, postcode:, area:, title_ca:, title_es:, description_ca:, description_es:)
        local_listing.save!

        images.each do |url|
          listing_image = local_listing.image_urls.find_by(url: url)
          unless listing_image.present?
            ImageUrl.create(caption: "#{listing_type} #{town_name}", url:, listing_id: local_listing.id)
          end
        end

        local_listing.image_urls.each do |image_url|
          unless images.include? image_url.url
            image_url.destroy
          end
        end

        # features.each do |feature|
        #   name = feature.at("Descripcion").text
        #   value = feature.at("Valor").text
        #   local_feature = local_listing.features.find_by(name:)
        #     if feature_web.present?
        #       feature_web.update!(value:)
        #     else
        #       Feature.create!(name:, value:, realestate_id: realestate_web.id)
        #     end
        # end

        # local_listing.features do |fw|
        #   unless features.include? fw.name
        #     fw.destroy
        #   end
        # end

      else
        local_listing = Listing.create(idfile:, idagency:, listing_type:, reference:, country:, speclocation:, typestreet:, namestreet:, numberstreet:, usable_area:, built_area:, salesprice:, rentprice:, region:, province:, town_name:, postcode:, area:, title_ca:, title_es:, description_ca:, description_es:, user_id:)
        local_listing.save!

        images.each do |url|
          Image.create!(url:, listing_id: local_listing.id)
        end

        # features.each do |feature|
        #   name = feature.at("Descripcion").text
        #   value = feature.at("Valor").text
        #   Feature.create!(name:, value:, listing_id: local_listing.id)
        # end
      end
    end

    # @all_listings = Listing.all
    # @all_towns = Town.all.pluck(:name)

    # @all_listings.each do |listing|
    #   if @all_towns.include? listing.town_name
    #     existing_town = Town.find_by(name: listing.town_name)
    #     listing.town_id = existing_town.id
    #     listing.save!
    #   else
    #     new_town = Town.create!(name: realestate_web.town_name)
    #     listing.town_id = new_town.id
    #     listing.save!
    #   end
    # end

    # @listings_without_coordinates = Listing.where(latitude: nil)

    # @listings_without_coordinates.each do |listing|
    #   results = Geocoder.search(listing.complete_address).empty? ? Geocoder.search(listing.town_name) : Geocoder.search(listing.complete_address)
    #   if results.present?
    #   lat_long = results.filistingt.coordinates
    #   listing.latitude = lat_long[0]
    #   listing.longitude = lat_long[1]
    #   listing.save!
    #   end
    #   sleep 1
    # end
  end
end
