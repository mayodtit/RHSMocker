class FactorSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :gender
end
