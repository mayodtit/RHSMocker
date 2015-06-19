class AddDisabledAtToMetadata < ActiveRecord::Migration
  def up
    add_column :metadata, :disabled_at, :datetime
  end

  def down
    remove_column :metadata, :disabled_at
  end
end
