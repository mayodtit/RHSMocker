class AddUuidToUser < ActiveRecord::Migration
  def change
  	    add_column :users, :uuid, :string, :limit => 32
  end
end
