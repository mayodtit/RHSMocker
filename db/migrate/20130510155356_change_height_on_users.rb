class ChangeHeightOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :height, :decimal, :precision => 9, :scale => 5, :default => 0
  end
end
