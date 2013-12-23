class AddPriorityToCustomCard < ActiveRecord::Migration
  def change
    add_column :custom_cards, :priority, :integer, null: false, default: 0
  end
end
