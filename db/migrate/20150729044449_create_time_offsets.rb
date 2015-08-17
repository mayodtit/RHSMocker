class CreateTimeOffsets < ActiveRecord::Migration
  def change
    create_table :time_offsets do |t|
      t.string  :offset_type,   null: false
      t.string  :direction,     null: false
      t.time    :fixed_time
      t.integer :num_days
      t.time    :relative_time

      t.timestamps
    end
  end
end
