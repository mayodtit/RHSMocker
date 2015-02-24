class AddTextToServiceTypes < ActiveRecord::Migration
  def change
    add_column :service_types, :description_template, :text
  end
end
