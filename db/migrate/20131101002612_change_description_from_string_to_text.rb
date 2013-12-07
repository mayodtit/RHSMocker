class ChangeDescriptionFromStringToText < ActiveRecord::Migration
  def up
  	change_column :symptom_selfcare_items, :description, :text
  end

  def down
  	change_column :symptom_selfcare_items, :description, :string
  end
end
