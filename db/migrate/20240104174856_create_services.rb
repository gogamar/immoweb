class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :summary_title_ca
      t.string :summary_title_es
      t.string :summary_title_en
      t.string :summary_title_fr
      t.string :summary_ca
      t.string :summary_es
      t.string :summary_en
      t.string :summary_fr
      t.string :description_title_ca
      t.string :description_title_es
      t.string :description_title_en
      t.string :description_title_fr
      t.string :description_ca
      t.string :description_es
      t.string :description_en
      t.string :description_fr

      t.timestamps
    end
  end
end
