class AddOutboundToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :outbound, :boolean, default: false, null: false
  end
end
