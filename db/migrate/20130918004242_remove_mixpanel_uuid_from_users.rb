class RemoveMixpanelUuidFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :mixpanel_uuid
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
