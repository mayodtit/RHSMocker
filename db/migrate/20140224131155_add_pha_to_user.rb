class AddPhaToUser < ActiveRecord::Migration
  def change
    add_column :users, :pha_id, :integer
  end
end
