class AddDataAttributesToSuggestedServices < ActiveRecord::Migration
  def change
    add_column :suggested_services, :title, :string
    add_column :suggested_services, :description, :text
    add_column :suggested_services, :message, :text
  end
end
