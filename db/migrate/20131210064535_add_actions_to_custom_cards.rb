class AddActionsToCustomCards < ActiveRecord::Migration
  def change
    add_column :custom_cards, :card_actions, :text
    add_column :custom_cards, :timeline_action, :text
  end
end
