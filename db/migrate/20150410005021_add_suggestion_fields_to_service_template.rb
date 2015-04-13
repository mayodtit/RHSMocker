class AddSuggestionFieldsToServiceTemplate < ActiveRecord::Migration
  def change
    add_column :service_templates, :suggestion_description, :text
    add_column :service_templates, :suggestion_message, :text
  end
end
