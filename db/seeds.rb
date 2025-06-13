

puts "Creating admin..."

User.create(email: "info@sistachfinques.com", password: "WiTaNeS#", admin: true)

GetPropertiesService.new.call

puts "Creating offices..."

Office.create(name: "Sistach Finques Estartit", address: "Avinguda de Grècia, 39, 17258 l'Estartit", phone_number: "972 100 834")

Office.create(name: "Sistach Finques Barcelona", address: "c/Rosselló 439, 08025 Barcelona", phone_number: "972 100 834")

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
  summary_ca: "Oferim una assistència especialitzada per a aquelles persones que estan pensant en comprar o vendre béns immobles, com ara cases. El nostre equip d'experts en l'àmbit immobiliari ajuda els clients a navegar de manera fluïda per tots els aspectes legals i els contractes relacionats amb aquestes transaccions, assegurant que els seus drets i interessos estiguin protegits durant tot el procés de compra o venda.",
  summary_es: "Ofrecemos asistencia especializada para personas que están considerando comprar o vender bienes inmuebles, como viviendas. Nuestro equipo de expertos en bienes raíces ayuda a los clientes a navegar sin problemas por todos los aspectos legales y contratos relacionados con estas transacciones, garantizando que sus derechos e intereses estén protegidos durante todo el proceso de compra o venta.",
  summary_en: "We provide specialized assistance for individuals thinking about buying or selling real estate properties, like homes. Our team of experts in real estate helps clients smoothly navigate all the legal aspects and contracts related to these transactions, ensuring that their rights and interests are safeguarded throughout the entire buying or selling process.",
  summary_fr: "Nous proposons une assistance spécialisée pour les personnes envisageant d'acheter ou de vendre des biens immobiliers, tels que des maisons. Notre équipe d'experts en immobilier aide les clients à naviguer en toute simplicité à travers tous les aspects juridiques et les contrats liés à ces transactions, garantissant que leurs droits et leurs intérêts soient protégés tout au long du processus d'achat ou de vente."
)

puts "#{Service.count} services created!"


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
