class ConditionSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :created_at, :updated_at, :snomed_name, :snomed_code,
             :content_id

  def content_id
    object.content.try(:id)
  end
end
