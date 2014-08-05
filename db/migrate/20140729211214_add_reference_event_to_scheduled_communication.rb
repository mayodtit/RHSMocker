class AddReferenceEventToScheduledCommunication < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :reference_event, :string
  end
end
