class ChangeTypeIdOnContent < ActiveRecord::Migration
  def up
    change_column :contents, :id, :string
  end

  def down
    change_column :contents, :id, :integer #DEFAULT NULL auto_increment PRIMARY KEY
  end
end
