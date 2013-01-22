class RenameAlternateIdColumn < ActiveRecord::Migration
  def up
  	rename_column :users, :alternate_id, :install_id
  end

  def down
  	rename_column :users, :install_id, :alternate_id
  end
end
