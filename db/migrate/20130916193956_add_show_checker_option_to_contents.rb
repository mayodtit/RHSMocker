class AddShowCheckerOptionToContents < ActiveRecord::Migration
  def change
    add_column :contents, :show_checker_option, :boolean
  end
end
