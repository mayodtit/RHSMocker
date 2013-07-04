class UpdateEthnicGroupColumns < ActiveRecord::Migration
  def up
    change_column :ethnic_groups, :name, :string, :null => false, :default => ''
    change_column :ethnic_groups, :ethnicity_code, :integer, :null => false, :default => 0
    change_column :ethnic_groups, :ordinal, :integer, :null => false, :default => 0
  end

  def down
    change_column :ethnic_groups, :name, :string
    change_column :ethnic_groups, :ethnicity_code, :string
    change_column :ethnic_groups, :ordinal, :integer
  end
end
