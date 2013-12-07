class AddSensitiveFlagToContent < ActiveRecord::Migration
  def change
    add_column :contents, :sensitive, :boolean, null: false, default: false
  end
end
