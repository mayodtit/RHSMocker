class AddShowMayoLogoToContent < ActiveRecord::Migration
  def change
    add_column :contents, :show_mayo_logo, :boolean, null: false, default: true
  end
end
