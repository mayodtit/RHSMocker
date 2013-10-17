class AddSelfcareToSymptoms < ActiveRecord::Migration
  def change
    add_column :symptoms, :selfcare, :string
  end
end
