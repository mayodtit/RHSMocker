class SystemActionTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :type, :message_text, :content, :content_id, :system_event_template_id
end
