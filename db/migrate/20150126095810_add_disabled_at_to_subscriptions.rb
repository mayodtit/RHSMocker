class AddDisabledAtToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :disabled_at, :timestamp
  end
end
