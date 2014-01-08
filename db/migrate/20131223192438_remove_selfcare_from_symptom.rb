class RemoveSelfcareFromSymptom < ActiveRecord::Migration
  def up
    remove_column :symptoms, :selfcare
  end

  def down
    add_column :symptoms, :selfcare, :text
  end
end
