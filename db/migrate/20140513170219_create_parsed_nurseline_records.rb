class CreateParsedNurselineRecords < ActiveRecord::Migration
  def change
    create_table :parsed_nurseline_records do |t|
      t.references :user
      t.references :consult
      t.references :phone_call
      t.references :nurseline_record
      t.text :text
      t.timestamps
    end
  end
end
