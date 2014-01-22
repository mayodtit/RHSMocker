class AddCardActionsToContent < ActiveRecord::Migration
  def change
    add_column :contents, :card_actions, :text
  end
end
