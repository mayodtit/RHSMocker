class AddSuggestedServiceToServices < ActiveRecord::Migration
  def change
    add_column :services, :suggested_service_id, :integer
  end
end
