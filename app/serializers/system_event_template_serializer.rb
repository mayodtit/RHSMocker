class SystemEventTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :name, :title, :description, :state, :unique_id, :version

  has_one :system_action_template

  has_many :system_relative_event_templates
  has_many :system_events
end
