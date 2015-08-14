class SystemEventTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :name, :title, :description, :state, :unique_id, :version

  has_one :system_action_template

  delegate :system_relative_event_templates, to: :object

  def attributes
    super.tap do |attrs|
      if options[:include_nested]
        attrs[:children] = system_relative_event_templates.serializer.as_json
      end
    end
  end
end
