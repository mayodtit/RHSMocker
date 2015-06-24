class ServiceTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes  :id, :name, :title, :description, :service_type_id, :time_estimate, :due_at, :user_facing, :service_request, :service_update, :version, :unique_id, :state, :state_events, :created_at, :unpublished_version_id

  delegate :unique_id, :published?, to: :object

  def attributes
    if options[:shallow]
      attributes = {
          id: object.id,
          title: object.title,
          description: object.description,
          service_type_id: object.service_type_id,
          time_estimate: object.time_estimate,
          due_at: due_at
      }
    else
      super.tap do |attributes|
        attributes.merge!(
            service_type: object.service_type
        )
        attributes[:task_templates] = object.task_templates.try(:serializer, options.merge(shallow: true)) if object.respond_to? :task_templates
      end
    end
  end

  def due_at
    Time.now.business_minutes_from(object.time_estimate)
  end

  def unpublished_version_id
    return nil unless unique_id && published?
    if unpublished_template = ServiceTemplate.unpublished.find_by_unique_id(unique_id)
      unpublished_template.id
    else
      nil
    end
  end
end
