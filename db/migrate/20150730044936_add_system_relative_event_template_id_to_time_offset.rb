class AddSystemRelativeEventTemplateIdToTimeOffset < ActiveRecord::Migration
  def change
    add_column :time_offsets, :system_relative_event_template_id, :integer
  end
end
