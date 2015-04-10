class AddServiceUpdateToServices < ActiveRecord::Migration
  def change
    add_column :services, :service_update, :text
  end
end
