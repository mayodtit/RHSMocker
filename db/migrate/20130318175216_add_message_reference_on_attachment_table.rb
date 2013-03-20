class AddMessageReferenceOnAttachmentTable < ActiveRecord::Migration
  def change
    add_column :attachments, :message_id, :integer
    add_index :attachments, :message_id
  end
end
