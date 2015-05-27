class AddColumnToScheduledCommunications < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :service_id, :integer
  end
end
