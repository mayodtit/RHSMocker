class AddShowMayoCopyrightToContent < ActiveRecord::Migration
  def change
    add_column :contents, :show_mayo_copyright, :boolean, :null => false, :default => true
  end
end
