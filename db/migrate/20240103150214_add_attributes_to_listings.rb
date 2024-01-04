class AddAttributesToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :listing_subtype, :string
    add_column :listings, :new_build, :boolean
    add_column :listings, :bank_owned, :boolean
    add_column :listings, :town_area, :string
    add_column :listings, :loc_precision, :string
    add_column :listings, :preservation, :string
    add_column :listings, :year_built, :string
    add_column :listings, :energy_cert, :string
    add_column :listings, :double_bedrooms, :integer
    add_column :listings, :single_bedrooms, :integer
    add_column :listings, :bathrooms, :integer
  end
end
