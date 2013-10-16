class RemoveFeatureBucketFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :feature_bucket
  end

  def down
    add_column :users, :feature_bucket, :string
  end
end
