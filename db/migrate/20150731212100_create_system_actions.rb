class CreateSystemActions < ActiveRecord::Migration
  def change
    create_table :system_actions do |t|
      t.references :system_event
      t.references :system_action_template
      t.references :result, polymorphic: true
      t.timestamps
    end
  end
end
