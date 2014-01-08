class SymptomMedicalAdviceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :symptom_id, :description, :symptom_medical_advice_item

  has_many :symptom_medical_advice_items

  def symptom_medical_advice_item
    symptom_medical_advice_items.serializer.as_json
  end
end
