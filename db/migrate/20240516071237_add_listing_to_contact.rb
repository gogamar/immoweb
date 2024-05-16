class AddListingToContact < ActiveRecord::Migration[7.0]
  def change
    add_reference :contacts, :listing, foreign_key: true
  end
end
