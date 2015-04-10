class SuggestedServiceSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :user_id, :service_template_id, :service_type_id, :title, :created_at,
             :updated_at, :suggestion_description, :suggestion_message

  def title
    object.service_template.title
  end

  def suggestion_description
    object.service_template.suggestion_description
  end

  def suggestion_message
    object.service_template.suggestion_message
  end

  def service_type_id
    object.service_type.try(:id)
  end
end
