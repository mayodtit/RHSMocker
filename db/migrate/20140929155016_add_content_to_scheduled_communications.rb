class AddContentToScheduledCommunications < ActiveRecord::Migration
  def change
    add_column :scheduled_communications, :content_id, :integer
  end
end
