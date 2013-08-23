class AddApiUserIdToNurselineRecords < ActiveRecord::Migration
  def change
    add_column :nurseline_records, :api_user_id, :integer
  end
end
