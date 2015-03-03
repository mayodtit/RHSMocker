class AddAbandonerIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :abandoner_id, :integer
  end
end
