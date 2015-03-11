class CreateProviderSearches < ActiveRecord::Migration
  def change
    create_table :provider_searches do |t|
      t.primary_key :id
      t.integer :provider_search_preferences_id
      t.string :state
      t.integer :user_id

      t.timestamps
    end
  end
end
