class RenameItemsToCards < ActiveRecord::Migration
  def up
    rename_table :items, :cards
  end

  def down
    rename_table :cards, :items
  end
end
