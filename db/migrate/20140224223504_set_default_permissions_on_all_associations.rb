class SetDefaultPermissionsOnAllAssociations < ActiveRecord::Migration
  def up
    Association.all.each do |a|
      a.send(:create_default_permission)
    end
  end

  def down
  end
end
