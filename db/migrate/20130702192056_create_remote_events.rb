class CreateRemoteEvents < ActiveRecord::Migration
  def change
    create_table :remote_events do |t|
      t.string :name, null: false
      t.integer :device_created_at, null: false
      t.string :device_language, null: false
      t.string :device_os, null: false
      t.string :device_os_version, null: false
      t.string :device_model, null: false
      t.integer :device_timezone_offset, null: false
      t.string :app_version, null: false
      t.string :app_build, null: false
      t.timestamps
    end
  end
end
