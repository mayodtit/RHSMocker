class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :user
      t.integer :resource_id
      t.string :resource_type
      t.string :state
      t.datetime :read_at
      t.datetime :saved_at
      t.datetime :dismissed_at
      t.timestamps
    end
  end
end
