class CreateProviderSearchResults < ActiveRecord::Migration
  def change
    create_table :provider_search_results do |t|
      t.primary_key :id
      t.integer :provider_profile_id
      t.integer :provider_search_id
      t.string :state

      t.timestamps
    end
  end
end
