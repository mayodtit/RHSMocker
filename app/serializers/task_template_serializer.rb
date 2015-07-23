class TaskTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :service_template_id, :name, :title, :description,
             :time_estimate, :service_ordinal

  delegate :service_template, :modal_template, :task_step_templates, to: :object

  def attributes
    super.tap do |attrs|
      attrs[:service_template] = service_template
      attrs[:modal_template] = modal_template
      attrs[:task_step_templates] = task_step_templates.serializer(options)
    end
  end
end
