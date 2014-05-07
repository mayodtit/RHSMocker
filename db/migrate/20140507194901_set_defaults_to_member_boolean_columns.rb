class SetDefaultsToMemberBooleanColumns < ActiveRecord::Migration
  def up
    change_column :users, :test_user, :boolean, null: false, default: false
    change_column :users, :marked_for_deletion, :boolean, null: false, default: false
  end

  def down
    change_column :users, :test_user, :boolean, null: true, default: nil
    change_column :users, :marked_for_deletion, :boolean, null: true, default: nil
  end
end
