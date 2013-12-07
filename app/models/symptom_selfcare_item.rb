class SymptomSelfcareItem < ActiveRecord::Base
  belongs_to :symptom_selfcare

  attr_accessible :symptom_selfcare, :symptom_selfcare_id, :description

  validates :symptom_selfcare, :description, presence: true
end
