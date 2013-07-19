class RemoveDefaultFromBmi < ActiveRecord::Migration
  def up
    change_column_default :weights, :bmi, nil
  end

  def down
    change_column_default :weights, :bmi, 0.0
  end
end
