class AddPhaRole < ActiveRecord::Migration
  def up
    Role.find_or_create_by_name! 'pha'
  end

  def down
    Role.find_by_name!('pha').destroy
  end
end
