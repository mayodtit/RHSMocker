class AddBucketToServiceTypes < ActiveRecord::Migration
  def change
    add_column :service_types, :bucket, :string
    add_index :service_types, [:bucket]
  end
end
