class AddTemplateToScheduledCommunications < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :template, :string
  end
end
