class MessageTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :text, :created_at, :updated_at
end
