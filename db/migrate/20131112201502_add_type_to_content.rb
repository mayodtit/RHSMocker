class AddTypeToContent < ActiveRecord::Migration
  def change
    add_column :contents, :type, :string
  end
end
