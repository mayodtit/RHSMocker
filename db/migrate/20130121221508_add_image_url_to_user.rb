class AddImageUrlToUser < ActiveRecord::Migration
  def change
  	add_column :users, :imageURL, :string
  end
end
