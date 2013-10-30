class AddGenderToSymptoms < ActiveRecord::Migration
  def change
    add_column :symptoms, :gender, :string
  end
end
