class SetDefaultLaterCountOnUserReading < ActiveRecord::Migration
  def self.up
    change_column :user_readings, :read_later_count, :integer, :default => 0, :null => false
  end

  def self.down
    # You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
