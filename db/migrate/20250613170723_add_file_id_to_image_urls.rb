class AddFileIdToImageUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :image_urls, :file_id, :string
  end
end
