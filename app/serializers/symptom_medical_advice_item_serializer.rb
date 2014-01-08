class SymptomMedicalAdviceItemSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :symptom_medical_advice_id, :description, :gender
end
