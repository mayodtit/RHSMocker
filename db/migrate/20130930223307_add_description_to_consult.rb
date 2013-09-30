class AddDescriptionToConsult < ActiveRecord::Migration
  def change
    add_column :consults, :description, :string
  end
end
