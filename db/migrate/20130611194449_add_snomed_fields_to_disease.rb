class AddSnomedFieldsToDisease < ActiveRecord::Migration
  def change
    add_column :diseases, :snomed_name, :string
    add_column :diseases, :snomed_code, :string
  end
end
