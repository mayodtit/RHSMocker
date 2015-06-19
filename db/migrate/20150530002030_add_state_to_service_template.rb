class AddStateToServiceTemplate < ActiveRecord::Migration
  def change
    add_column :service_templates, :state, :string
  end
end
