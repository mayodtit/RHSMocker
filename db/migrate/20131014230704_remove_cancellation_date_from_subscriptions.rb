class RemoveCancellationDateFromSubscriptions < ActiveRecord::Migration
  def up
    remove_column :subscriptions, :cancellation_date
  end

  def down
    add_column :subscriptions, :cancellation_date, :date
  end
end
