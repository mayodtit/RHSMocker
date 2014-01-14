class SymptomSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :description, :patient_type, :gender,
             :symptom_medical_advice, :symptom_selfcare

  has_many :symptom_medical_advices
  has_many :symptom_selfcares

  def symptom_medical_advice
    symptom_medical_advices.serializer.as_json
  end

  def symptom_selfcare
    symptom_selfcares.first.try(:serializer).try(:as_json)
  end
end
