require 'nokogiri'
require 'net/ftp'

puts "Connecting to the FTP server..."

ftp = Net::FTP.new('ftp.ghestia.cat')
ftp.login(ENV['GH_L'], ENV['GH_P'])

ftp.nlst.each do |filename|
  ftp.getbinaryfile(filename, "public/xml/#{filename}") if File.extname(filename) == '.xml'
end

puts "Parsing the XML file..."

doc = Nokogiri::XML(File.open("public/xml/INMUEBLES_MODIFICADOS.xml"))
ghestia_listings = doc.search('inmueble')

ghestia_listings.each do |gh_listing|
  l_status = gh_listing.search('Estado').first.content if gh_listing.search('Estado').first.present?
  l_idfile = gh_listing.search('IdFicha').first.content if gh_listing.search('IdFicha').first
  l_published_on = gh_listing.search('FechaAlta').first.content if gh_listing.search('FechaAlta').first.present?
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
    typestreet: Listing::TYPESTREET[l_typestreet],
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
    bedrooms: l_num_bedrooms,
    published_on: l_published_on.to_date
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

  l_features = gh_listing.search("Caracteristica")

  l_features.each do |feature|
    feature_name = feature.at("Descripcion").text
    feature_value = feature.at("Valor").text

    if feature_name == "Estado conservación"
      local_listing.preservation = Listing::PRESERVATION[feature_value]
    elsif feature_name == "Nº de dormitorios"
      local_listing.bedrooms = feature_value
    elsif feature_name == "Nº de baños"
      local_listing.bathrooms = feature_value
    elsif feature_name == "Categoría del consumo energético"
      local_listing.energy_cert = feature_value
    end

    local_listing.save!

    local_listing.features.clear

    local_feature_name = Feature::FEATURE_NAMES[feature_name]

    if local_feature_name.present?
      local_feature = Feature.find_by(name: local_feature_name)
      if local_feature.present? && !local_listing.features.include?(local_feature)
        local_listing.features << local_feature
        local_listing.save!
      else
        new_feature = Feature.create!(name: local_feature_name)
        local_listing.features << new_feature
        local_listing.save!
      end
    end
  end

  listing_town = Town.find_or_create_by(name_es: l_town_name) do |town|
    town.name_es = l_town_name
    town.save!
  end

  local_listing.town_id = listing_town.id
  local_listing.save!
end

# # assign a town id to listings that don't have one
# Listing.where(town_id: nil).each do |listing|
#   puts "updating town_id for listing #{listing.id}..."
#   listing_town = Town.find_or_create_by(name_es: listing.town_name) do |town|
#     town.name_es = listing.town_name
#     town.save!
#   end
#   listing.town_id = listing_town.id
#   listing.save!
#   puts "town_id updated!"
# end

# delete listings that are not in the XML file
Listing.where.not(idfile: doc.search('IdFicha').map(&:text)).each do |listing|
  if listing.operation == "sale"
    listing.update(mark: "sold")
  elsif listing.operation == "rent"
    listing.update(mark: "rented")
  end
end

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

puts "Creating offices..."

Office.create(name: "Sistach Finques Estartit", address: "Avinguda de Grècia, 39, 17258 l'Estartit", phone_number: "972 100 834")

Office.create(name: "Sistach Finques Barcelona", address: "c/Rosselló 439, 08022 Barcelona", phone_number: "972 100 834")

Office.create(name: "Sistach Finques Berga", address: "c/Roser 1, 1-2, 08600 Berga", phone_number: "972 100 834")

puts "Done!"

puts "Creating services..."

Service.create(
  summary_title_ca: "Identificar propietats en venda i lloguer",
  summary_title_es: "Identificar propiedades en venta y alquiler",
  summary_title_en: "Identifying Properties for Sale and Rent",
  summary_title_fr: "Identification des propriétés à vendre et à louer",
  summary_ca: "El nostre servei d'identificació de propietats en venda i lloguer ajuda als clients a trobar la llar perfecta que compleixi les seves necessitats i desitjos. Els nostres especialistes estan dedicats a buscar i seleccionar les millors propietats disponibles en el mercat immobiliari, tant per a la venda com per al lloguer. Amb la nostra experiència i coneixement del mercat, assegurem que els clients trobin propietats que es adaptin al seu pressupost i requisits, fent que la recerca d'un nou immoble sigui més senzilla i efectiva.",
  summary_es: "Nuestro servicio de identificación de propiedades en venta y alquiler ayuda a los clientes a encontrar el hogar perfecto que cumpla con sus necesidades y deseos. Nuestros especialistas están dedicados a buscar y seleccionar las mejores propiedades disponibles en el mercado inmobiliario, tanto para la venta como para el alquiler. Con nuestra experiencia y conocimiento del mercado, aseguramos que los clientes encuentren propiedades que se ajusten a su presupuesto y requisitos, haciendo que la búsqueda de una nueva propiedad sea más fácil y efectiva.",
  summary_en: "Our service of identifying properties for sale and rent helps clients find the perfect home that meets their needs and desires. Our specialists are dedicated to searching and selecting the best properties available in the real estate market, both for sale and for rent. With our experience and market knowledge, we ensure that clients find properties that fit their budget and requirements, making the search for a new property easier and more effective.",
  summary_fr: "Notre service d'identification de propriétés à vendre et à louer aide les clients à trouver le foyer parfait qui répond à leurs besoins et désirs. Nos spécialistes sont dédiés à la recherche et à la sélection des meilleures propriétés disponibles sur le marché immobilier, tant à la vente qu'à la location. Avec notre expérience et notre connaissance du marché, nous nous assurons que les clients trouvent des propriétés qui correspondent à leur budget et à leurs exigences, rendant la recherche d'une nouvelle propriété plus facile et plus efficace."
)

Service.create(
  summary_title_ca: "Avaluacions de propietats",
  summary_title_es: "Valoraciones inmobiliarias",
  summary_title_en: "Property valuations",
  summary_title_fr: "Évaluations immobilières",
  summary_ca: "Els nostres serveis d'avaluació de propietats us proporcionen una valoració precisa i exhaustiva del valor actual del vostre bé immoble. Amb la nostra experiència, oferim avaluacions completes de propietats que us ajuden a prendre decisions informades quan compreu, veniu o invertiu en béns immobles. El nostre equip de professionals està dedicat a proporcionar avaluacions precises de propietats, donant-vos confiança en el valor dels vostres actius immobiliaris.",
  summary_es: "Nuestros servicios de evaluación de propiedades le proporcionan una valoración precisa y exhaustiva del valor actual de su bien inmueble. Con nuestra experiencia, ofrecemos evaluaciones completas de propiedades que le ayudan a tomar decisiones informadas al comprar, vender o invertir en bienes raíces. Nuestro equipo de profesionales está dedicado a proporcionar valoraciones precisas de propiedades, brindándole confianza en el valor de sus activos inmobiliarios.",
  summary_en: "Our property evaluation services provide you with a precise and thorough assessment of your property's current market value. With our expertise, we offer comprehensive property evaluations that help you make informed decisions when buying, selling, or investing in real estate. Our team of professionals is dedicated to delivering accurate property valuations, giving you confidence in the value of your real estate assets.",
  summary_fr: "Nos services d'évaluation immobilière vous fournissent une évaluation précise et approfondie de la valeur actuelle de votre bien immobilier. Forts de notre expérience, nous proposons des évaluations complètes de biens immobiliers qui vous aident à prendre des décisions éclairées lors de l'achat, de la vente ou de l'investissement dans l'immobilier. Notre équipe de professionnels est dédiée à fournir des évaluations précises de biens immobiliers, vous donnant confiance dans la valeur de vos actifs immobiliers."
)

Service.create(
  summary_title_ca: "Publiquem la seva propietat als portals immobiliaris principals",
  summary_title_es: "Publicamos su propiedad en los principales portales inmobiliarios",
  summary_title_en: "We Publish Your Property on Main Property Portals",
  summary_title_fr: "Nous publions votre propriété sur les principaux portails immobiliers",
  summary_ca: "La nostra agència immobiliària està especialitzada en promoure la vostra propietat de manera efectiva mitjançant la seva inclusió als portals immobiliaris més importants. D'aquesta manera, maximitzem la visibilitat de la vostra propietat davant compradors o llogaters potencials, assegurant-vos una venda o lloguer més ràpids i exitosos. Confieu en nosaltres per fer que la vostra propietat sigui notada on més importa.",
  summary_es: "Nuestra agencia inmobiliaria se especializa en promocionar su propiedad de manera efectiva al incluirla en los portales inmobiliarios más prominentes. De esta manera, maximizamos la visibilidad de su propiedad ante posibles compradores o inquilinos, garantizando una venta o alquiler más rápido y exitoso. Confíe en nosotros para que su propiedad sea notada donde más importa.",
  summary_en: "Our real estate agency specializes in promoting your property effectively by listing it on the most prominent property portals. By doing so, we maximize the visibility of your property to potential buyers or renters, ensuring a faster and more successful sale or lease. Trust us to get your property noticed where it matters most.",
  summary_fr: "Notre agence immobilière est spécialisée dans la promotion efficace de votre propriété en la listant sur les portails immobiliers les plus importants. Ce faisant, nous maximisons la visibilité de votre propriété auprès des acheteurs potentiels ou des locataires, garantissant ainsi une vente ou une location plus rapide et réussie. Faites-nous confiance pour faire remarquer votre propriété là où cela compte le plus."
)

Service.create(
  summary_title_ca: "Assessorament legal en la compra o venda de béns immobles",
  summary_title_es: "Asistencia legal en la compra o venta de bienes inmuebles",
  summary_title_en: "Legal assistance in buying or selling real estate",
  summary_title_fr: "Assistance juridique dans l'achat ou la vente de biens immobiliers",
  summary_ca: "Oferim una assistència especialitzada per a aquelles persones que estan pensant en comprar o vendre béns immobles, com ara cases. El nostre equip d'experts en l'àmbit immobiliari ajuda els clients a navegar de manera fluïda per tots els aspectes legals i els contractes relacionats amb aquestes transaccions, assegurant que els seus drets i interessos estiguin protegits durant tot el procés de compra o venda.\"",
  summary_es: "Ofrecemos asistencia especializada para personas que están considerando comprar o vender bienes inmuebles, como viviendas. Nuestro equipo de expertos en bienes raíces ayuda a los clientes a navegar sin problemas por todos los aspectos legales y contratos relacionados con estas transacciones, garantizando que sus derechos e intereses estén protegidos durante todo el proceso de compra o venta.",
  summary_en: "We provide specialized assistance for individuals thinking about buying or selling real estate properties, like homes. Our team of experts in real estate helps clients smoothly navigate all the legal aspects and contracts related to these transactions, ensuring that their rights and interests are safeguarded throughout the entire buying or selling process.",
  summary_fr: "Nous proposons une assistance spécialisée pour les personnes envisageant d'acheter ou de vendre des biens immobiliers, tels que des maisons. Notre équipe d'experts en immobilier aide les clients à naviguer en toute simplicité à travers tous les aspects juridiques et les contrats liés à ces transactions, garantissant que leurs droits et leurs intérêts soient protégés tout au long du processus d'achat ou de vente."
)

puts "#{Service.count} services created!"
