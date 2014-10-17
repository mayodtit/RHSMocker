class AddUsersWithCompletedServiceToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :users_with_completed_service, :integer
  end
end
