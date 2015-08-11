class SystemRelativeEventTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :name, :title, :description, :state, :unique_id, :version

  belongs_to :root_event_template
  has_one :time_offset
  has_one :system_action_template
end
