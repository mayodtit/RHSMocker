class SystemActionTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :type, :message_text, :content, :content_id, :system_event_template_id, :service_template

  delegate :published_versioned_resource, to: :object

  def service_template
    if published_versioned_resource.is_a? ServiceTemplate
      published_versioned_resource.serializer.as_json
    end
  end
end
