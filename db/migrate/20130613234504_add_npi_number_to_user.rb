class AddNpiNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :npi_number, :string, :limit => 10
  end
end
