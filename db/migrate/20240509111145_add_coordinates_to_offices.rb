class AddCoordinatesToOffices < ActiveRecord::Migration[7.0]
  def change
    add_column :offices, :latitude, :float
    add_column :offices, :longitude, :float
  end
end
