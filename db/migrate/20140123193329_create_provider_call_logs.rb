class CreateProviderCallLogs < ActiveRecord::Migration
  def change
    create_table :provider_call_logs do |t|
      t.string :npi
      t.integer :number
      t.integer :user_id

      t.timestamps
    end
  end
end
