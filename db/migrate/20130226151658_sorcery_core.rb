class SorceryCore < ActiveRecord::Migration
  def change
    add_column :users, :crypted_password, :string, :default=> nil
    add_column :users, :auth_token, :string, :default=> nil
    add_column :users, :salt, :string, :default=> nil
  end
end