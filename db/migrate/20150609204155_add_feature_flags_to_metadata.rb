class AddFeatureFlagsToMetadata < ActiveRecord::Migration
  def up
    add_column :metadata, :type, :string
    add_column :metadata, :description, :text
  end

  def down
    remove_column :metadata, :type
    remove_column :metadata, :description
  end
end
