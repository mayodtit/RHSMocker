class SymptomSelfcare < ActiveRecord::Base
  belongs_to :symptom
  has_many :symptom_selfcare_items

  attr_accessible :symptom, :symptom_id, :description

  validates :symptom, :description, presence: true
end
