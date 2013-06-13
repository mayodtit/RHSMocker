class RemoveDefaultHeightFromUser < ActiveRecord::Migration
  def up
    change_column_default :users, :height, nil
  end

  def down
    change_column_default :users, :height, 0.0
  end
end
