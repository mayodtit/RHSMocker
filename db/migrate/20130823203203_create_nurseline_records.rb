class CreateNurselineRecords < ActiveRecord::Migration
  def change
    create_table :nurseline_records do |t|
      t.text :payload
      t.timestamps
    end
  end
end
