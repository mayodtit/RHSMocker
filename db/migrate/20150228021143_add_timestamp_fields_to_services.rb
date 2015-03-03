class AddTimestampFieldsToServices < ActiveRecord::Migration
  def change
    add_column :services, :completed_at, :datetime
    add_column :services, :abandoned_at, :datetime
  end
end
