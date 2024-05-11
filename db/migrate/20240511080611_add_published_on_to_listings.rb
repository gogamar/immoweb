class AddPublishedOnToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :published_on, :date
  end
end
