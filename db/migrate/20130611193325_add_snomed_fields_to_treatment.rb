class AddSnomedFieldsToTreatment < ActiveRecord::Migration
  def change
    add_column :treatments, :snomed_name, :string
    add_column :treatments, :snomed_code, :string
  end
end
