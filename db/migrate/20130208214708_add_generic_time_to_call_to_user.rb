class AddGenericTimeToCallToUser < ActiveRecord::Migration
  def change
    add_column :users, :generic_call_time, :string
  end
end
