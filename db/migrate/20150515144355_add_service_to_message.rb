class AddServiceToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :service_id, :integer
  end
end
