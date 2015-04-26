class AddDelinquentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :delinquent, :boolean
  end
end
