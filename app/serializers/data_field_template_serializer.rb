class DataFieldTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :service_template_id, :name, :type,
             :required_for_service_start
end
