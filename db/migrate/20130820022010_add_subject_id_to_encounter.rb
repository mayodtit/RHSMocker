class AddSubjectIdToEncounter < ActiveRecord::Migration
  def change
    add_column :encounters, :subject_id, :integer, :null => false, :default => 0
  end
end
