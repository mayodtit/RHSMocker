class AddSnomedIdsToAllergies < ActiveRecord::Migration
  def change
    add_column :allergies, :concept_id, :string
    add_column :allergies, :description_id, :string
  end
end
