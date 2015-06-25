class TaskStepSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :description, :ordinal, :details, :template, :completed,
             :injected_details, :injected_template

  delegate :data_fields, :completed?, to: :object

  def attributes
    super.tap do |attrs|
      attrs[:data_fields] = data_fields.serializer.as_json
    end
  end

  def completed
    completed?
  end
end
