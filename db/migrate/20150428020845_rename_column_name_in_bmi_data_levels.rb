class RenameColumnNameInBmiDataLevels < ActiveRecord::Migration
  def up
    rename_column :bmi_data_levels, :age, :age_in_months
  end

  def down
    rename_column :bmi_data_levels, :age_in_months, :age
  end
end
