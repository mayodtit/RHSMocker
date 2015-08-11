class SystemActionTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :type, :message_text, :content, :content_id, :system_event_template, :system_event_template_id

  has_many :system_actions
end
