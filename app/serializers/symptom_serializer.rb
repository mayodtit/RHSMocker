class SymptomSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :description, :patient_type, :gender

  has_one :symptom_medical_advice
  has_one :symptom_selfcare
end
