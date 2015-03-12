class AddTimedServiceFlagToServiceTemplate < ActiveRecord::Migration
  def change
    add_column :service_templates, :timed_service, :boolean, default: false
  end
end
