class AddPriceAndDescriptionToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :description, :string
    add_column :plans, :price, :string
  end
end
