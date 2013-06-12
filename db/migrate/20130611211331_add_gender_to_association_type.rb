class AddGenderToAssociationType < ActiveRecord::Migration
  def change
    add_column :association_types, :gender, :string
  end
end
