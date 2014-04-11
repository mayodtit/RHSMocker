class AddLastContactAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_contact_at, :datetime
  end
end
