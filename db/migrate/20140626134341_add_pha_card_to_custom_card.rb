class AddPhaCardToCustomCard < ActiveRecord::Migration
  def change
    add_column :custom_cards, :pha_card, :boolean
  end
end
