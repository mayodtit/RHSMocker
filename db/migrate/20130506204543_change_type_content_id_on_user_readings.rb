class ChangeTypeContentIdOnUserReadings < ActiveRecord::Migration
  def up
    change_column :user_readings, :content_id, :string
  end

  def down
    change_column :user_readings, :content_id, :integer
  end
end
