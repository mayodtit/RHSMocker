class AddSystemToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :system, :boolean
  end
end
