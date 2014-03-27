class AddMasterToConsults < ActiveRecord::Migration
  def change
    add_column :consults, :master, :boolean, null: false, default: false
  end
end
