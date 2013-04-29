class AddExtraFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :ethnic_group_id, :integer
    add_column :users, :diet_id, :integer
    add_column :users, :blood_type, :string
    add_column :users, :holds_phone_in, :string
  end
end
