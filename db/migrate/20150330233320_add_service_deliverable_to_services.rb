class AddServiceDeliverableToServices < ActiveRecord::Migration
  def change
    add_column :services, :service_deliverable, :text
  end
end
