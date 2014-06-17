class AddOnCallToUser < ActiveRecord::Migration
  def change
    add_column :users, :on_call, :boolean, default: false, null: true
  end
end
