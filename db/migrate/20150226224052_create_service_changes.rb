class CreateServiceChanges < ActiveRecord::Migration
  def change
    create_table :service_changes do |t|
      t.references :service, null: false
      t.string :event
      t.string :from
      t.string :to
      t.text :data
      t.references :actor, null: false
      t.timestamp :created_at, null: false
      t.string :reason
    end
    add_index :service_changes, :service_id
  end
end
