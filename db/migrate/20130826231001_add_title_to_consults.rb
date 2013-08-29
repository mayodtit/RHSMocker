class AddTitleToConsults < ActiveRecord::Migration
  def change
    add_column :consults, :title, :string
  end
end
