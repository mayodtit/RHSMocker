class RenameAddressTypeToName < ActiveRecord::Migration
  def up
    rename_column :addresses, :type, :name
  end

  def down
    rename_column :addresses, :name, :type
  end
end
