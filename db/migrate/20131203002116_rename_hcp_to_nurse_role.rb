class RenameHcpToNurseRole < ActiveRecord::Migration
  def up
    Role.connection.execute('UPDATE roles SET name=\'nurse\' WHERE name=\'hcp\'')
  end

  def down
    Role.connection.execute('UPDATE roles SET name=\'hcp\' WHERE name=\'nurse\'')
  end
end
