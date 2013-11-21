class Symptom < ActiveRecord::Base
  has_many :symptoms_factors
  has_many :factors, through: :symptoms_factors
  has_many :symptom_medical_advice
  has_one  :symptom_selfcare
  has_and_belongs_to_many :contents

  attr_accessible :name, :patient_type, :description, :selfcare, :gender

  validates :name, :description, presence: true
  validates :patient_type, inclusion: {in: %w(adult child)}
  validates :gender, inclusion: {in: %w(M F)}, allow_nil: true
end
