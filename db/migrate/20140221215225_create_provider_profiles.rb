class CreateProviderProfiles < ActiveRecord::Migration
  def change
    create_table :provider_profiles do |t|
      t.integer :npi_number, limit: 10
      t.string :taxonomy_code, limit: 10

      t.timestamps
    end
  end
end
