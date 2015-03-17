class ChangeServiceDescriptionToText < ActiveRecord::Migration
  def up
    change_column :services, :description, :text
  end

  def down
    change_column :services, :description, :string
  end
end
