class SymptomSelfcareItemSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :symptom_selfcare_id, :description
end
