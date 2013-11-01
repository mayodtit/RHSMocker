class SymptomSelfcare < ActiveRecord::Base
  attr_accessible :description, :symptom_id
  has_many :symptom_selfcare_items
end
