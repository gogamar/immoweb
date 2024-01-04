require 'nokogiri'
require 'net/ftp'

# puts "Connecting to the FTP server..."

# ftp = Net::FTP.new('ftp.ghestia.cat')
# ftp.login(ENV['GH_L'], ENV['GH_P'])

# ftp.nlst.each do |filename|
#   ftp.getbinaryfile(filename, "public/xml/#{filename}") if File.extname(filename) == '.xml'
# end

puts "Parsing the XML file..."

doc = Nokogiri::XML(File.open("public/xml/INMUEBLES_MODIFICADOS.xml"))
ghestia_listings = doc.search('inmueble')

ghestia_listings.each do |gh_listing|
  l_status = gh_listing.search('Estado').first.content if gh_listing.search('Estado').first.present?
  l_idfile = gh_listing.search('IdFicha').first.content if gh_listing.search('IdFicha').first
  l_idagency = gh_listing.search('IdAgencia').first.content if gh_listing.search('IdAgencia').first.present?
  l_type = gh_listing.search('TipoGenerico').first.content if gh_listing.search('TipoGenerico').first.present?
  l_subtype = gh_listing.search('TipoEspecifico').first.content if gh_listing.search('TipoEspecifico').first.present?
  l_ref_number = gh_listing.search('Referencia').first.content if gh_listing.search('Referencia').first.present?
  l_country = gh_listing.search('Pais').first.content if gh_listing.search('Pais').first.present?
  l_speclocation = gh_listing.search('SituacionConcreta').first.content if gh_listing.search('SituacionConcreta').first.present?
  l_typestreet = gh_listing.search('TipoVia').first.content if gh_listing.search('TipoVia').first.present?
  l_namestreet = gh_listing.search('NombreVia').first.content if gh_listing.search('NombreVia').first.present?
  l_numberstreet = gh_listing.search('NumeroVia').first.content if gh_listing.search('NumeroVia').first.present?
  l_usable_area = gh_listing.search('SuperficieUtil').first.content if gh_listing.search('SuperficieUtil').first.present?
  l_built_area = gh_listing.search('SuperficieConstruida').first.content if gh_listing.search('SuperficieConstruida').first.present?
  l_salesprice = gh_listing.search('PrecioVenta').first.content if gh_listing.search('PrecioVenta').first.present?
  l_rentprice = gh_listing.search('PrecioAlquiler').first.content if gh_listing.search('PrecioAlquiler').first.present?
  l_town_name = gh_listing.search('Localidad').first.content if gh_listing.search('Localidad').first.present?
  l_region = gh_listing.search('Comunidad').first.content if gh_listing.search('Comunidad').first.present?
  l_province = gh_listing.search('Provincia').first.content if gh_listing.search('Provincia').first.present?
  l_postcode = gh_listing.search('CodigoPostal').first.content if gh_listing.search('CodigoPostal').first.present?
  l_town_area = gh_listing.search('Zona').first.content if gh_listing.search('Zona').first.present?
  l_title_ca = gh_listing.search('SloganCAT').first.content if gh_listing.search('SloganCAT').first.present?
  l_title_es = gh_listing.search('Slogan').first.content if gh_listing.search('Slogan').first.present?
  l_description_ca = gh_listing.search('AnuncioCAT').first.content if gh_listing.search('AnuncioCAT').first.present?
  l_description_es = gh_listing.search('Anuncio').first.content if gh_listing.search('Anuncio').first.present?

  l_preservation = gh_listing.xpath('.//Caracteristica[Descripcion="Estado conservación"]')
  l_preservation_state = l_preservation.at("Valor").text if l_preservation.present?

  l_bedrooms = gh_listing.xpath('.//Caracteristica[Descripcion="Nº de dormitorios"]')
  l_num_bedrooms = l_bedrooms.at("Valor").text if l_bedrooms.present?

  unless l_title_ca.present?
    l_title_ca = l_title_es
  end

  unless l_description_ca.present?
    l_description_ca = l_description_es
  end

  listing_attributes = {
    status: Listing::LISTING_STATUS[l_status],
    listing_type: Listing::LISTING_TYPE[l_type],
    listing_subtype: Listing::LISTING_SUBTYPE[l_subtype],
    ref_number: l_ref_number,
    idagency: l_idagency,
    country: l_country,
    speclocation: l_speclocation,
    typestreet: l_typestreet,
    namestreet: l_namestreet,
    numberstreet: l_numberstreet,
    usable_area: l_usable_area,
    built_area: l_built_area,
    operation: l_salesprice.present? ? "sale" : "rent",
    salesprice: l_salesprice,
    rentprice: l_rentprice,
    region: l_region,
    province: l_province,
    town_name: l_town_name,
    postcode: l_postcode,
    town_area: l_town_area,
    title_ca: l_title_ca,
    title_es: l_title_es,
    description_ca: l_description_ca,
    description_es: l_description_es,
    preservation: Listing::PRESERVATION[l_preservation_state],
    bedrooms: l_num_bedrooms
  }

  local_listing = Listing.find_by(idfile: l_idfile)
  if local_listing
    local_listing.update(listing_attributes)
  else
    local_listing = Listing.create(listing_attributes.merge(idfile: l_idfile))
  end
  local_listing.user_id = User.find_by(admin: true).id
  local_listing.save!

  l_images = gh_listing.search('foto url').map(&:text)
  l_images.each do |url|
    existing_image = local_listing.image_urls.find_by(url: url)
    if existing_image
      existing_image.update(caption: "#{local_listing.listing_type} #{local_listing.town_name}")
    else
      ImageUrl.create(url: url, caption: "#{local_listing.listing_type} #{local_listing.town_name}", listing_id: local_listing.id)
    end
  end
  local_listing.image_urls.each do |image_url|
    unless l_images.include? image_url.url
      image_url.destroy
    end
  end

  # l_features = gh_listing.search("Caracteristica")

  # l_features.each do |feature|
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
puts "Done!"
