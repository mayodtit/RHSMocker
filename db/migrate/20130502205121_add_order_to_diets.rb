class AddOrderToDiets < ActiveRecord::Migration
  def change
    add_column :diets, :order, :integer
  end
end
