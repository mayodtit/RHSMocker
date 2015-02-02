class AddSnomedIdsToAllergies < ActiveRecord::Migration
  def change
    add_column :allergies, :concept_id, :integer
    add_column :allergies, :description_id, :integer
  end
end
