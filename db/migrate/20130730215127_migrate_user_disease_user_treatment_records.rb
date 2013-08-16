class MigrateUserDiseaseUserTreatmentRecords < ActiveRecord::Migration
  def up
    UserDiseaseTreatment.find_each do |udt|
      udt.user_diseases << UserDisease.find(udt.user_disease_id) if udt.user_disease_id
    end

    remove_column :user_disease_treatments, :user_disease_id
  end

  def down
    add_column :user_disease_treatments, :user_disease_id, :integer
  end
end
