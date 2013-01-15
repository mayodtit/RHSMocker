class AddShortNameToAuthor < ActiveRecord::Migration
  def change
    add_column :authors, :shortName, :string
  end
end
