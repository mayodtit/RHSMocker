class CreateSuggestedServiceChanges < ActiveRecord::Migration
  def change
    create_table :suggested_service_changes do |t|
      t.references :suggested_service
      t.references :actor
      t.string :event
      t.string :from
      t.string :to
      t.text :data
      t.timestamps
    end
  end
end
