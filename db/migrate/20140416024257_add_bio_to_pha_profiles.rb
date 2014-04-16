class AddBioToPhaProfiles < ActiveRecord::Migration
  def change
    add_column :pha_profiles, :bio, :text
  end
end
