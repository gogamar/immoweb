class Feature < ApplicationRecord
  has_and_belongs_to_many :listings, join_table: "listings_features"

  FEATURE_NAMES = {
    "Calefacción" => "heating",
    "Parking" => "parking",
    "Vistas" => "views",
    "Ascensor" => "lift",
    "Zona comunitaria" => "community_area",
    "Zona ajardinada" => "garden_area",
    "Piscina" => "pool"
  }
end
