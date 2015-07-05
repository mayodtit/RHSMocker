class TaskStepSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :description, :ordinal, :details, :template, :completed,
             :injected_template

  delegate :completed?, :task_step_data_fields, to: :object

  def attributes
    super.tap do |attrs|
      attrs[:data_fields] = data_fields.serializer.as_json
    end
  end

  def completed
    completed?
  end

  private

  def data_fields
    task_step_data_fields.map do |task_step_data_field|
      task_step_data_field.data_field.serializer.as_json.tap do |data_field|
        data_field[:required] = task_step_data_field.required_for_task_step_completion?
      end
    end
  end
end
