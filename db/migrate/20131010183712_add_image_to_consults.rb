class AddImageToConsults < ActiveRecord::Migration
  def change
    add_column :consults, :image, :string
  end
end
