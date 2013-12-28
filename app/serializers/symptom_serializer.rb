class SymptomSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :description, :patient_type, :gender,
             :symptom_medical_advice

  has_many :symptom_medical_advices
  has_one :symptom_selfcare

  def symptom_medical_advice
    symptom_medical_advices.serializer.as_json
  end
end
