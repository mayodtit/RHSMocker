class AddLoggingLevelCommandToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :logging_level, :integer
    add_column :sessions, :logging_command, :integer
  end
end
