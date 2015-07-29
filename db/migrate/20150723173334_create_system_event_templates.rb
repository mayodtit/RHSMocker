class CreateSystemEventTemplates < ActiveRecord::Migration
  def change
    create_table :system_event_templates do |t|
      t.string  :name,                   null: false
      t.string  :title,                  null: false
      t.text    :description
      t.string  :unique_id,              null: false
      t.integer :version,    default: 0, null: false
      t.string  :state

      t.timestamps
    end
  end
end
