class CreateUserFeatureGroups < ActiveRecord::Migration
  def change
    create_table :user_feature_groups do |t|
      t.references :user
      t.references :feature_group
      t.timestamps
    end
  end
end
