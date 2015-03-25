class AddSnomedIdsToConditions < ActiveRecord::Migration
  def change
    add_column :conditions, :concept_id, :string
    add_column :conditions, :description_id, :string
  end
end
