class AddOffHoursFlagToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :off_hours, :boolean, null: false, default: false
  end
end
