class CreateNewPhoneCalls < ActiveRecord::Migration
  def change
    create_table :phone_calls do |t|
      t.references :user
      t.timestamps
    end
    add_column :messages, :phone_call_id, :integer
  end
end
