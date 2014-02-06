class AddMemberToUser < ActiveRecord::Migration
  def up
    add_column :users, :member_flag, :boolean
    Member.update_all(member_flag: true)
    add_index :users, [:email, :member_flag], unique: true
  end

  def down
    remove_index :users, [:email, :member_flag]
    remove_column :users, :member_flag
  end
end
