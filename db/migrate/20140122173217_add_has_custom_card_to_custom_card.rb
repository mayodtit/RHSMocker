class AddHasCustomCardToCustomCard < ActiveRecord::Migration
  def change
    add_column :custom_cards, :has_custom_card, :boolean, null: false, default: false
  end
end
