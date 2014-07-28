class AddTypeToScheduledCommunications < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :type, :string
  end
end
