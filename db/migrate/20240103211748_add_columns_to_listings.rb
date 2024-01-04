class AddColumnsToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :town_name, :string
    add_column :listings, :local_status, :string
    add_column :listings, :mark, :string
  end
end
