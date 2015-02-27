class ChangeDefaultOnDelinquent < ActiveRecord::Migration
  def up
    change_column_default :users, :delinquent, nil
  end

  def down
    change_column_default :users, :delinquent, false
  end
end
