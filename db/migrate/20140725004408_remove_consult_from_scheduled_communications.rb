class RemoveConsultFromScheduledCommunications < ActiveRecord::Migration
  def up
    remove_column :scheduled_communications, :consult_id
  end

  def down
    add_column :scheduled_communications, :consult_id, :integer
  end
end
