class ChangeTextTypeInMessages < ActiveRecord::Migration
  def up
    change_column :messages, :text, :text, :limit => nil
  end

  def down
    change_column :messages, :text, :string
  end
end
