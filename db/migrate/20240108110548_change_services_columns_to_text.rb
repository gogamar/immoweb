class ChangeServicesColumnsToText < ActiveRecord::Migration[7.0]
  def change
    change_column :services, :summary_ca, :text
    change_column :services, :summary_es, :text
    change_column :services, :summary_en, :text
    change_column :services, :summary_fr, :text
    change_column :services, :description_ca, :text
    change_column :services, :description_es, :text
    change_column :services, :description_en, :text
    change_column :services, :description_fr, :text
  end
end
