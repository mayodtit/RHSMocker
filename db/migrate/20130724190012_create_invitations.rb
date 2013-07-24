class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :member
      t.references :invited_member
      t.timestamps
    end
  end
end
