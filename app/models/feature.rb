class Feature < ApplicationRecord
  has_and_belongs_to_many :listings

  FEATURE_NAMES = {
    "Calefacción" => "heating",
    "Parking" => "parking",
    "Vistas" => "views",
    "Ascensor" => "lift",
    "Zona comunitaria" => "community_area",
    "Zona ajardinada" => "garden_area",
    "1ª línea" => "pool"
  }
end
