class ServiceTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes  :id, :name, :title, :description, :service_type_id, :time_estimate

  def attributes
    if options[:shallow]
      attributes = {
          id: object.id,
          title: object.title,
          description: object.description,
          service_type_id: object.service_type_id,
          time_estimate: object.time_estimate
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
end
