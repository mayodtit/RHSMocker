class AddCompleteToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :complete, :boolean
  end
end
