class AddContentToMessageTemplate < ActiveRecord::Migration
  def change
    add_column :message_templates, :content_id, :integer
  end
end
