class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :town, optional: true
  has_many :image_urls, dependent: :destroy
  has_and_belongs_to_many :features
  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?
  has_many_attached :photos

  LISTING_STATUS = {
    "Disponible" => "available",
    "Reservado" => "reserved",
    "Arras" => "earnest_deposit",
    "Contrato" => "contract",
    "Operación realizada" => "transaction_completed",
    "Alquilado" => "rented",
    "Alquilado con opción a compra" => "rented_with_option_to_buy",
    "Baja" => "off_market"
  }

  LISTING_TYPE = {
    "Piso" => "housing",
    "Casa" => "house",
    "Parking" => "parking",
    "Local" => "shop",
    "Oficina" => "office",
    "Suelo" => "land",
    "Edificio" => "building",
    "Industrial" => "warehouse",
    "Hotel" => "hotel",
    "Otros" => "other"
  }

  LISTING_SUBTYPE = {
    "Apartamento" => "apartment",
    "Ático" => "penthouse",
    "Bajos con jardín" => "ground_floor_with_garden",
    "Casa de pueblo" => "townhouse",
    "Dúplex" => "duplex",
    "Estudio" => "studio",
    "Loft" => "loft",
    "Piso" => "apartment",
    "Tríplex" => "triplex",
    "Bungalow" => "bungalow",
    "Casa rural" => "country_house",
    "Chalet / Torre" => "chalet",
    "Masia" => "farmhouse",
    "Unifamiliar adosada" => "terraced",
    "Unifamiliar aïllada" => "detached",
    "Suelo urbano" => "urban_land",
    "Plaza de aparcamiento" => "parking_space",
    "interior" => "parking_interior",
    "Otros" => "other",
    "Otro" => "other"
  }

  PRESERVATION = {
    "Regular" => "regular",
    "Buena" => "good",
    "Excelente" => "excellent",
    "Muy bueno" => "very_good",
    "Necesita reforma" => "needs_renovation",
    "Nuevo" => "new",
    "Reformado" => "renovated",
    "Reformado a estrenar" => "newly_renovated"
  }
end
