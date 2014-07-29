class AddRelativeDaysToScheduledCommunication < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :relative_days, :integer
  end
end
