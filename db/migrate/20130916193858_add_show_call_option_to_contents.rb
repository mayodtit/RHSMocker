class AddShowCallOptionToContents < ActiveRecord::Migration
  def change
    add_column :contents, :show_call_option, :boolean
  end
end
