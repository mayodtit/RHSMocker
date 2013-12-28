class SymptomSelfcareSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :symptom_id, :description

  has_many :symptom_selfcare_items
end
