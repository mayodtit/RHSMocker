class AddUnreadByCpToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :unread_by_cp, :boolean
    add_index :messages, :unread_by_cp
  end
end
