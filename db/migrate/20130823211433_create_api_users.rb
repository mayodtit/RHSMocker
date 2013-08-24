class CreateApiUsers < ActiveRecord::Migration
  def change
    create_table :api_users do |t|
      t.string :name
      t.string :auth_token
      t.timestamp :disabled_at
      t.timestamps
    end
  end
end
