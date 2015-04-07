class AddIndexesToSignupTables < ActiveRecord::Migration
  def change
    add_index :enrollments, :email
    add_index :user_agreements, %i(user_id agreement_id)
    add_index :cards, %i(user_id resource_id resource_type)
    add_index :user_readings, %i(user_id content_id)
  end
end
