class AddPremiumToFeatureGroup < ActiveRecord::Migration
  def change
    add_column :feature_groups, :premium, :boolean, null: false, default: false
  end
end
