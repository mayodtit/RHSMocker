class AddReasonEscalatedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :reason_escalated, :text
  end
end
