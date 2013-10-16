class AddDescriptionToSymptoms < ActiveRecord::Migration
  def change
    add_column :symptoms, :description, :string
  end
end
