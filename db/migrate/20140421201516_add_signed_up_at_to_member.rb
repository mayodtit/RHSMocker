class AddSignedUpAtToMember < ActiveRecord::Migration
  def change
    add_column :users, :signed_up_at, :datetime
  end
end
