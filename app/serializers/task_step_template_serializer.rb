class TaskStepTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :task_template_id, :description, :ordinal, :details,
             :template

  delegate :task_step_data_field_templates, to: :object

  def attributes
    super.tap do |attrs|
      attrs[:task_step_data_field_templates] = task_step_data_field_templates
    end
  end
end
