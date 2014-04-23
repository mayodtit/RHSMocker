class AddSignedUpAtIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, [:type, :signed_up_at]
  end
end
