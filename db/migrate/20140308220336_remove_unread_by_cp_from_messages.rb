class RemoveUnreadByCpFromMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :unread_by_cp
  end

  def down
    add_column :messages, :unread_by_cp, :boolean
  end
end
