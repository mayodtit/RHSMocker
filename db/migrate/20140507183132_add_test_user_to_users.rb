class AddTestUserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :test_user, :boolean
  end
end
