class RenameUserOfferingToCredits < ActiveRecord::Migration
  def up
    remove_index :user_offerings, :user_id
    remove_index :user_offerings, :offering_id
    rename_table :user_offerings, :credits
  end

  def down
    rename_table :credits, :user_offerings
    add_index :user_offerings, :user_id
    add_index :user_offerings, :offering_id
  end
end
