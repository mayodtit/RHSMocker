class RenameColumnNamesInBmiDataLevels < ActiveRecord::Migration
  def up
    rename_column :bmi_data_levels, :l, :power_in_transformation
    rename_column :bmi_data_levels, :m, :median
    rename_column :bmi_data_levels, :s, :coefficient_of_variation
  end

  def down
    rename_column :bmi_data_levels, :power_in_transformation, :l
    rename_column :bmi_data_levels, :median, :m
    rename_column :bmi_data_levels, :coefficient_of_variation, :s
  end
end
