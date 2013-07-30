class UpdateUserDiseaseTreatmentsFields < ActiveRecord::Migration
  def up
    rename_column :user_disease_treatments, :doctor_user_id, :doctor_id
  end

  def down
    rename_column :user_disease_treatments, :doctor_id, :doctor_user_id
  end
end
