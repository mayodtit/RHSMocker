class AddReadToEncountersUser < ActiveRecord::Migration
  def change
    add_column :encounters_users, :read, :boolean
  end
end
