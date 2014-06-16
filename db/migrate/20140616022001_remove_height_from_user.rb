class RemoveHeightFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :height
  end

  def down
    add_column :users, :height, :decimal, precision: 9, scale: 5
  end
end
