class AddInvitationTokenToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :token, :string
    add_index :invitations, :token
    add_column :invitations, :state, :string
  end
end
