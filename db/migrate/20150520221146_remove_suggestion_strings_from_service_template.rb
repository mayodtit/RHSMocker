class RemoveSuggestionStringsFromServiceTemplate < ActiveRecord::Migration
  def up
    remove_column :service_templates, :suggestion_description
    remove_column :service_templates, :suggestion_message
  end

  def down
    add_column :service_templates, :suggestion_description, :text
    add_column :service_templates, :suggestion_message, :text
  end
end
