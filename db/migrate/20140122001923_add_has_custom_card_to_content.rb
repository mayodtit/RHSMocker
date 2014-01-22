class AddHasCustomCardToContent < ActiveRecord::Migration
  def change
    add_column :contents, :has_custom_card, :boolean, null: false, default: false
  end
end
