class AddContentIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :content_id, :integer
    add_index :messages, :content_id
  end
end
