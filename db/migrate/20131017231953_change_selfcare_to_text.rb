class ChangeSelfcareToText < ActiveRecord::Migration
  def up
    change_column :symptoms, :selfcare, :text
  end

  def down
  	change_column :symptoms, :selfcare, :string
  end
end
