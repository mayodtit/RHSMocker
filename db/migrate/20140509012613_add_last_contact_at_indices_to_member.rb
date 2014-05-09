class AddLastContactAtIndicesToMember < ActiveRecord::Migration
  def change
    add_index :users, [:type, :last_contact_at]
    add_index :users, [:type, :pha_id, :last_contact_at]
  end
end
