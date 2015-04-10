class ServiceTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes  :id, :name, :title, :description, :service_type_id, :time_estimate, :due_at, :user_facing

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
end
