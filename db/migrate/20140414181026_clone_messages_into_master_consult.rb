class CloneMessagesIntoMasterConsult < ActiveRecord::Migration
  def up
    unless column_exists? :messages, :cloned, :boolean
      add_column :messages, :cloned, :boolean
    end
  end

  def down
    remove_column :messages, :cloned
  end
end
