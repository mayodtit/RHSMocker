class AddIndexToEnrollments < ActiveRecord::Migration
  def change
    add_index :enrollments, :token
  end
end
