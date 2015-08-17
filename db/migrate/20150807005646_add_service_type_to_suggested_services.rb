class AddServiceTypeToSuggestedServices < ActiveRecord::Migration
  def change
    add_column :suggested_services, :service_type_id, :integer
  end
end
