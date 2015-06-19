class AddColumnToServiceTemplate < ActiveRecord::Migration
  def change
    add_column :service_templates, :unique_id, :string
  end
end
