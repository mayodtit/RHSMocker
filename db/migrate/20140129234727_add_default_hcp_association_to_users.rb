class AddDefaultHcpAssociationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_hcp_association_id, :integer
  end
end
