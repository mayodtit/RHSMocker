class AddProviderTaxonomyCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider_taxonomy_code, :string
  end
end
