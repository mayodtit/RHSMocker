class SetNotNullOnDiets < ActiveRecord::Migration
  def up
    change_column :diets, :name, :string, :null => false, :default => ''
    change_column :diets, :ordinal, :integer, :null => false, :default => 0
  end

  def down
    change_column :diets, :name, :string
    change_column :diets, :ordinal, :integer
  end
end
