class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.string :header_background
      t.string :header_title_ca
      t.string :header_title_es
      t.string :header_title_en
      t.string :header_title_fr
      t.string :action_phrase_ca
      t.string :action_phrase_es
      t.string :action_phrase_en
      t.string :action_phrase_fr
      t.string :action_button_ca
      t.string :action_button_es
      t.string :action_button_en
      t.string :action_button_fr
      t.string :reviews_title_ca
      t.string :reviews_title_es
      t.string :reviews_title_en
      t.string :reviews_title_fr
      t.string :reviews_subtitle_ca
      t.string :reviews_subtitle_es
      t.string :reviews_subtitle_en
      t.string :reviews_subtitle_fr
      t.string :add_property_title_ca
      t.string :add_property_title_es
      t.string :add_property_title_en
      t.string :add_property_title_fr
      t.string :add_property_subtitle_ca
      t.string :add_property_subtitle_es
      t.string :add_property_subtitle_en
      t.string :add_property_subtitle_fr
      t.string :posts_title_ca
      t.string :posts_title_es
      t.string :posts_title_en
      t.string :posts_title_fr
      t.string :posts_subtitle_ca
      t.string :posts_subtitle_es
      t.string :posts_subtitle_en
      t.string :posts_subtitle_fr
      t.string :contact_title_ca
      t.string :contact_title_es
      t.string :contact_title_en
      t.string :contact_title_fr
      t.string :contact_subtitle_ca
      t.string :contact_subtitle_es
      t.string :contact_subtitle_en
      t.string :contact_subtitle_fr

      t.timestamps
    end
  end
end
