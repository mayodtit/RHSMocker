class NuxAnswerSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :text
end