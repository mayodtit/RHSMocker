class AddHeightToUsers < ActiveRecord::Migration
  def change
    add_column :users, :height, :decimal, :precision => 6, :scale => 2, :default => 0
  end
end
