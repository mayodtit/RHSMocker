class FactorGroupSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name
  has_many :factors
end
