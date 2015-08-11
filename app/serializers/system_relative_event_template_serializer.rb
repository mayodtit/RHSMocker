class SystemRelativeEventTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :name, :title, :description, :state, :unique_id, :version, :root_event_template, :root_event_template_id

  has_one :time_offset
  has_one :system_action_template
  has_many :system_events
end
