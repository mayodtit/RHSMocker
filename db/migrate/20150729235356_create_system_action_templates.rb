class CreateSystemActionTemplates < ActiveRecord::Migration
  def change
    create_table :system_action_templates do |t|
      t.references :system_event_template
      t.string :type
      t.text :message_text
      t.references :content
      t.timestamps
    end
  end
end
