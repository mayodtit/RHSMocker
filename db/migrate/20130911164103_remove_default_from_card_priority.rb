class RemoveDefaultFromCardPriority < ActiveRecord::Migration
  def up
    change_column_default :cards, :priority, nil
  end

  def down
    change_column_default :cards, :priority, 0
  end
end
