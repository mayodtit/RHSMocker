class TaskStepTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :task_template_id, :description, :ordinal, :details,
             :template

  delegate :data_field_templates, to: :object

  def attributes
    super.tap do |attrs|
      attrs[:data_field_templates] = data_field_templates
    end
  end
end
