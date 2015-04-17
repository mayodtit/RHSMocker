class AddBmiLevelToWeights < ActiveRecord::Migration
  def change
    add_column :weights, :bmi_level, :string
  end
end
