class CreatePhoneCalls < ActiveRecord::Migration
  def change
    create_table :phone_calls do |t|
      t.string :time_to_call
      t.string :time_zone
      t.string :status
      t.text :summary
      t.datetime :start_time
      t.integer :counter
      t.references :message

      t.timestamps
    end
    add_index :phone_calls, :message_id
  end
end
