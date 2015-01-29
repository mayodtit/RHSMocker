class DeprecateStateInUsers < ActiveRecord::Migration
  def change_column
    remove_column :users, :state, :string
  end
end
