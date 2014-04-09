class AddSubjectToUserProgram < ActiveRecord::Migration
  def change
    add_column :user_programs, :subject_id, :integer
  end
end
