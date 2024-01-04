class CreateJoinTableListingsFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :listings_features, id: false do |t|
      t.belongs_to :listing
      t.belongs_to :feature
    end

    add_index :listings_features, [:listing_id, :feature_id], unique: true
  end
end
