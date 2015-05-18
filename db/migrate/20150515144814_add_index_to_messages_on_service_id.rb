class AddIndexToMessagesOnServiceId < ActiveRecord::Migration
  def change
    add_index :messages, :service_id
  end
end
