class SymptomMedicalAdvice < ActiveRecord::Base
  belongs_to :symptom
  has_many :symptom_medical_advice_item

  attr_accessible :symptom, :symptom_id, :description

  validates :symptom, :description, presence: true
end
