class AddSnomedFieldsToDisease < ActiveRecord::Migration
  def change
    add_column :disease, :snomed_name, :string
    add_column :disease, :snomed_code, :string
  end
end
