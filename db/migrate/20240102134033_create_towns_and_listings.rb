class CreateTownsAndListings < ActiveRecord::Migration[7.0]
  def change
    create_table :towns do |t|
      t.string :name_ca
      t.string :name_es
      t.string :name_en
      t.string :name_fr
      t.text :description_ca
      t.text :description_es
      t.text :description_en
      t.text :description_fr
      t.timestamps
    end

    create_table :listings do |t|
      t.string :status, default: "new"
      t.string :ref_number
      t.string :idfile
      t.string :idagency
      t.string :listing_type
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :typestreet
      t.string :namestreet
      t.string :numberstreet
      t.string :postcode
      t.string :speclocation
      t.string :region
      t.string :province
      t.string :country
      t.float :usable_area
      t.float :built_area
      t.string :operation
      t.decimal :salesprice
      t.decimal :rentprice
      t.string :title_ca
      t.string :title_es
      t.string :title_en
      t.string :title_fr
      t.text :description_ca
      t.text :description_es
      t.text :description_en
      t.text :description_fr
      t.integer :bedrooms
      t.boolean :terrace
      t.boolean :lift
      t.boolean :featured, default: false
      t.references :town, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
