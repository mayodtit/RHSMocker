class AddClientDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :client_data, :text
  end
end
