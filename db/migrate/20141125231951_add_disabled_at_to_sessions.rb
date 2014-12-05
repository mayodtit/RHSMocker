class AddDisabledAtToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :disabled_at, :datetime
  end
end
