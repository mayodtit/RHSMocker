class SymptomMedicalAdviceItem < ActiveRecord::Base
  belongs_to :symptom_medical_advice

  attr_accessible :symptom_medical_advice, :symptom_medical_advice_id, :description

  validates :symptom_medical_advice, :description, presence: true
end
