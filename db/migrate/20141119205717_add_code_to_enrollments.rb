class AddCodeToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :code, :string
  end
end
