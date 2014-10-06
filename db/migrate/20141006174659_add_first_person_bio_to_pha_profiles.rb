class AddFirstPersonBioToPhaProfiles < ActiveRecord::Migration
  def change
    add_column :pha_profiles, :first_person_bio, :text
  end
end
