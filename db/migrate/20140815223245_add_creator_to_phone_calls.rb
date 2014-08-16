class AddCreatorToPhoneCalls < ActiveRecord::Migration
  def change
    add_column :phone_calls, :creator_id, :integer
  end
end
