class SymptomSelfcareItem < ActiveRecord::Base
  belongs_to :symptom_selfcare
  attr_accessible :description, :symptom_selfcare_id
end
