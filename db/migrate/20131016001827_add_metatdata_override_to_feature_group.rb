class AddMetatdataOverrideToFeatureGroup < ActiveRecord::Migration
  def change
    add_column :feature_groups, :metadata_override, :text
  end
end
