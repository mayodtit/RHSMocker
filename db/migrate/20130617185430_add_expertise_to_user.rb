class AddExpertiseToUser < ActiveRecord::Migration
  def change
    add_column :users, :expertise, :string
  end
end
