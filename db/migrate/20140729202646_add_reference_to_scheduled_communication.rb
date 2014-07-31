class AddReferenceToScheduledCommunication < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :reference_id, :integer
    add_column :scheduled_communications, :reference_type, :string
  end
end
