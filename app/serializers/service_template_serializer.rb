class ServiceTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes  :id, :name, :title, :description, :service_type_id, :service_type, :time_estimate

  def attributes
    super.tap do |attributes|
      attributes[:task_templates] = object.task_templates.try(:serializer, options.merge(shallow: true)) if object.respond_to? :task_templates
    end
  end

end