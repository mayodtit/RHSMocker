class AddPhaIdIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :pha_id
  end
end
