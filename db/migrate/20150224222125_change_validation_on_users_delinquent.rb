class ChangeValidationOnUsersDelinquent < ActiveRecord::Migration
  def up
    change_column_null :users, :delinquent, true
  end

  def down
    change_column_null :users, :delinquent, false
  end
end
