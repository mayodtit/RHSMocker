class AddImageUrlToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :imageURL, :string
  end

  def down
  	drop_column :users, :imageURL, :string
  end
end

