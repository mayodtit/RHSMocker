class AddCancellationDateToUserPlans < ActiveRecord::Migration
  def change
    add_column :user_plans, :cancellation_date, :date
  end
end
