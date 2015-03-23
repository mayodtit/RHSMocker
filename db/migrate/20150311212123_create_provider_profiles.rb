class CreateProviderProfiles < ActiveRecord::Migration
  def change
    create_table :provider_profiles do |t|
      t.primary_key :id
      t.string :npi_number, limit: 10
      t.string :first_name
      t.string :last_name
      t.string :image_url
      t.string :gender
      t.text :ratings

      t.timestamps
    end
  end
end
