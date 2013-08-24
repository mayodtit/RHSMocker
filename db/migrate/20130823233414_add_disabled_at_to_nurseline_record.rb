class AddDisabledAtToNurselineRecord < ActiveRecord::Migration
  def change
    add_column :nurseline_records, :disabled_at, :datetime
  end
end
