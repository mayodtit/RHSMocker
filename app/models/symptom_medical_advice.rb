class SymptomMedicalAdvice < ActiveRecord::Base
  attr_accessible :description, :symptom_id
  has_many :symptom_medical_advice_item 
end
