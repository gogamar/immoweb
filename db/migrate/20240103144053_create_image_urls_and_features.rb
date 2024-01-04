class CreateImageUrlsAndFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :image_urls do |t|
      t.string :caption
      t.string :url
      t.references :listing, null: false, foreign_key: true
      t.timestamps
    end

    create_table :features do |t|
      t.string :name
      t.timestamps
    end
  end
end
