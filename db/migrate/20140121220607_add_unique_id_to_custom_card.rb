class AddUniqueIdToCustomCard < ActiveRecord::Migration
  def change
    add_column :custom_cards, :unique_id, :string
  end
end
