class AddKinsightsFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :kinsights_token, :string
    add_column :users, :kinsights_patient_url, :string
    add_column :users, :kinsights_profile_url, :string
  end
end
