class RepurposePermissionsModel < ActiveRecord::Migration
  def up
    remove_column :permissions, :user_id
    remove_column :permissions, :name
    remove_column :permissions, :level
    add_column :permissions, :basic_info, :string
    add_column :permissions, :medical_info, :string
    add_column :permissions, :care_team, :string
  end

  def down
    remove_column :permissions, :basic_info
    remove_column :permissions, :medical_info
    remove_column :permissions, :care_team
    add_column :permissions, :user_id, :integer
    add_column :permissions, :name, :string
    add_column :permissions, :level, :string
  end
end
