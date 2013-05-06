class AddFieldsToAllergies < ActiveRecord::Migration
  def change
    add_column :allergies, :snomed_name, :string
    add_column :allergies, :snomed_code, :string
    add_column :allergies, :food_allergen, :boolean
    add_column :allergies, :environment_allergen, :boolean
    add_column :allergies, :medication_allergen, :boolean
  end
end
