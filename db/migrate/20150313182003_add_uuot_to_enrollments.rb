class AddUuotToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :uout, :string
  end
end
