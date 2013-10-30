class RemoveGenericCallTime < ActiveRecord::Migration
  def up
    remove_column :users, :generic_call_time
  end

  def down
    add_column :users, :generic_call_time, :string
  end
end
