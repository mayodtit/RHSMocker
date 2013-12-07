class RenameMetadataTableColumns < ActiveRecord::Migration
  def up
    rename_column :metadata, :key, :mkey
    rename_column :metadata, :value, :mvalue
  end

  def down
    rename_column :metadata, :mkey, :key
    rename_column :metadata, :mvalue, :value
  end
end
