class AddSynonymIdToAllergies < ActiveRecord::Migration
  def change
    add_column :allergies, :master_synonym_id, :integer
  end
end
