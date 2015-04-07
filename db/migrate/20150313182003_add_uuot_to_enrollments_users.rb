class AddUuotToEnrollmentsUsers < ActiveRecord::Migration
  def change
    add_column :enrollments, :unique_on_boarding_user_token, :string
    add_column :users, :unique_on_boarding_user_token, :string
  end
end
