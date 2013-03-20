class AddFeatureBucketToUsers < ActiveRecord::Migration
  def change
    add_column :users, :feature_bucket, :string
  end
end
