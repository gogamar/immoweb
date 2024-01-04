class Town < ApplicationRecord
  has_many :listings
  has_many_attached :photos
end
