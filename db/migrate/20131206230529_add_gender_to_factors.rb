class AddGenderToFactors < ActiveRecord::Migration
  def change
    add_column :factors, :gender, :string
  end
end
