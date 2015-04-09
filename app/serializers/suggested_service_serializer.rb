class SuggestedServiceSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :user_id, :service_template_id, :service_type_id, :title, :created_at, :updated_at

  def title
    object.service_template.title
  end

  def service_type_id
    object.service_type.try(:id)
  end
end
