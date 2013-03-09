class RemoveOldColumnsFromUserTable < ActiveRecord::Migration
  def change
    remove_column :users, :uuid
    remove_column :users, :password_digest
  end
end
