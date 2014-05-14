class AddParsedNurselineRecordToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :parsed_nurseline_record_id, :integer
  end
end
