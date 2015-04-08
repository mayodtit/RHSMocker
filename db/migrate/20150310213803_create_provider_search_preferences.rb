class CreateProviderSearchPreferences < ActiveRecord::Migration
  def change
    create_table :provider_search_preferences do |t|
      t.primary_key :id
      t.string :lat
      t.string :lon
      t.decimal :distance
      t.string :gender
      t.string :specialty_uid
      t.string :insurance_uid

      t.timestamps
    end
  end
end
