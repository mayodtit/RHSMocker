class AddPriorityToItems < ActiveRecord::Migration
  def change
    add_column :items, :priority, :integer, :null => false, :default => 0
  end
end
