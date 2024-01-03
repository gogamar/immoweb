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
    realestates = doc.search('inmueble')

    realestates.each do |realestate|
      realestate_web = Realestate.find_by(idfile: realestate.search('IdFicha').first.content)
      idfile = realestate.search('IdFicha').first.content if realestate.search('IdFicha').first
      idagency = realestate.search('IdAgencia').first.content if realestate.search('IdAgencia').first.present?
      rstype = realestate.search('TipoGenerico').first.content if realestate.search('TipoGenerico').first.present?
      reference = realestate.search('Referencia').first.content if realestate.search('Referencia').first.present?
      country = realestate.search('Pais').first.content if realestate.search('Pais').first.present?
      speclocation = realestate.search('SituacionConcreta').first.content if realestate.search('SituacionConcreta').first.present?
      typestreet = realestate.search('TipoVia').first.content if realestate.search('TipoVia').first.present?
      namestreet = realestate.search('NombreVia').first.content if realestate.search('NombreVia').first.present?
      numberstreet = realestate.search('NumeroVia').first.content if realestate.search('NumeroVia').first.present?
      usurface = realestate.search('SuperficieUtil').first.content if realestate.search('SuperficieUtil').first.present?
      csurface = realestate.search('SuperficieConstruida').first.content if realestate.search('SuperficieConstruida').first.present?
      salesprice = realestate.search('PrecioVenta').first.content if realestate.search('PrecioVenta').first.present?
      rentprice = realestate.search('PrecioAlquiler').first.content if realestate.search('PrecioAlquiler').first.present?
      town_name = realestate.search('Localidad').first.content if realestate.search('Localidad').first.present?
      region = realestate.search('Comunidad').first.content if realestate.search('Comunidad').first.present?
      province = realestate.search('Provincia').first.content if realestate.search('Provincia').first.present?
      postcode = realestate.search('CodigoPostal').first.content if realestate.search('CodigoPostal').first.present?
      area = realestate.search('Zona').first.content if realestate.search('Zona').first.present?
      title = realestate.search('SloganCAT').first.content if realestate.search('SloganCAT').first.present?
      ad = realestate.search('AnuncioCAT').first.content if realestate.search('AnuncioCAT').first.present?
      # CHANGE THIS!
      user_id = 1

      images = realestate.search('foto url').map(&:text)
      features = realestate.search("Caracteristica")

      if realestate_web.present?

        realestate_web.update(idagency:, rstype:, reference:, country:, speclocation:, typestreet:, namestreet:, numberstreet:, usurface:, csurface:, salesprice:, rentprice:, region:, province:, town_name:, postcode:, area:, title:, ad:)
        realestate_web.save!

        images.each do |url|
          image_web = realestate_web.images.find_by(url: url)
          unless image_web.present?
            Image.create(url:, realestate_id: realestate_web.id)
          end
        end

        realestate_web.images.each do |web_image|
          unless images.include? web_image.url
            web_image.destroy
          end
        end

        features.each do |feature|
          name = feature.at("Descripcion").text
          value = feature.at("Valor").text
          feature_web = realestate_web.features.find_by(name:)
            if feature_web.present?
              feature_web.update!(value:)
            else
              Feature.create!(name:, value:, realestate_id: realestate_web.id)
            end
        end

        realestate_web.features do |fw|
          unless features.include? fw.name
            fw.destroy
          end
        end

      else
        realestate_web = Realestate.create(idfile:, idagency:, rstype:, reference:, country:, speclocation:, typestreet:, namestreet:, numberstreet:, usurface:, csurface:, salesprice:, rentprice:, region:, province:, town_name:, postcode:, area:, title:, ad:, user_id:)
        realestate_web.save!

        images.each do |url|
          Image.create!(url:, realestate_id: realestate_web.id)
        end

        features.each do |feature|
          name = feature.at("Descripcion").text
          value = feature.at("Valor").text
          Feature.create!(name:, value:, realestate_id: realestate_web.id)
        end
      end
    end

    @all_realestates = Realestate.all
    @all_towns = Town.all.pluck(:name)

    @all_realestates.each do |rs|
      if @all_towns.include? rs.town_name
        existing_town = Town.find_by(name: rs.town_name)
        rs.town_id = existing_town.id
        rs.save!
      else
        new_town = Town.create!(name: realestate_web.town_name)
        rs.town_id = new_town.id
        rs.save!
      end
    end

    @realestates_without_coordinates = Realestate.where(latitude: nil)

    @realestates_without_coordinates.each do |rs|
      results = Geocoder.search(rs.complete_address).empty? ? Geocoder.search(rs.town_name) : Geocoder.search(rs.complete_address)
      if results.present?
      lat_long = results.first.coordinates
      rs.latitude = lat_long[0]
      rs.longitude = lat_long[1]
      rs.save!
      end
      sleep 1
    end
  end
end
