class AddEthnicityCodeToEthnicGroups < ActiveRecord::Migration
  def change
    add_column :ethnic_groups, :ethnicity_code, :string
  end
end
