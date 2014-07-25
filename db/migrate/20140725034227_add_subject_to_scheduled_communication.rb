class AddSubjectToScheduledCommunication < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :subject, :string
  end
end
