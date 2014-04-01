class CreatePhaProfiles < ActiveRecord::Migration
  def change
    create_table :pha_profiles do |t|
      t.references :user
      t.string :bio_image
      t.timestamps
    end
  end
end
