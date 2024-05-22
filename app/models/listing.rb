class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :town, optional: true
  has_many :image_urls, dependent: :destroy
  has_and_belongs_to_many :features, join_table: "listings_features"
  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?
  has_many_attached :photos

  scope :filter_by_reference, -> (ref) { self.where("reference ilike ?", ref) }
  scope :filter_by_sale, -> { self.where(operation: "sale")}
  scope :filter_by_rent, -> { self.where(operation: "rent")}
  scope :filter_by_town, -> (param_values) { includes(:town).where('town.name' => param_values) }
  scope :filter_by_type, -> (listing_type) { where(listing_type: listing_type) }
  scope :filter_by_min, -> (min) { where('salesprice >= ?', min.to_i) }
  scope :filter_by_max, -> (max) { where('salesprice <= ?', max.to_i) }
  scope :filter_by_bedrooms, -> (num_bedrooms) { where(bedrooms: num_bedrooms.to_i)}

  OPERATIONS = [ "buy", "rent", "holidays" ]

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
    "reformado" => "renovated",
    "Reformado a estrenar" => "newly_renovated"
  }

  # fixme: add more types of streets from Ghestia

  TYPESTREET = {
    "Calle" => "street",
    "Avenida" => "avenue",
    "Paseo" => "promenade",
    "Plaza" => "square",
    "Carretera" => "road",
    "Bulevar" => "boulevard",
    "Callejón" => "alley",
    "Pasaje" => "passage"
  }

  def has_feature?(feature_name)
    features.exists?(name: feature_name)
  end

  def property_address
    if address.present?
      return address
    elsif speclocation.present?
      "#{speclocation} #{town_name}"
    else
      "#{I18n.t(typestreet)} #{namestreet} #{numberstreet} #{town_name}"
    end
  end

  def property_surface
    surface = built_area || usable_area
    "#{surface.round} m²" if surface.present?
  end
end
