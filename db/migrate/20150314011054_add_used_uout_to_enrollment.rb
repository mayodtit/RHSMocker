class AddUsedUoutToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :used_uout, :boolean
  end
end
