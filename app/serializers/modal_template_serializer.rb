class ModalTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :description, :accept, :reject, :updated_at, :created_at
end
