class TaskStepSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :description, :ordinal, :completed

  delegate :data_fields, to: :object

  def attributes
    super.tap do |attrs|
      attrs[:data_fields] = data_fields.serializer.as_json
    end
  end
end
