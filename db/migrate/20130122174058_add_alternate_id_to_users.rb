class AddAlternateIdToUsers < ActiveRecord::Migration
  def change
  	    add_column :users, :alternate_id, :string, :limit => 36
  end
end
