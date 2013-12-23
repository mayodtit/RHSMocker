class Symptom < ActiveRecord::Base
  has_many :factor_groups
  has_one :symptom_medical_advice
  has_one :symptom_selfcare

  attr_accessible :name, :patient_type, :description, :selfcare, :gender

  validates :name, :description, presence: true
  validates :patient_type, inclusion: {in: %w(adult child)}
  validates :gender, inclusion: {in: %w(M F)}, allow_nil: true
end
