class SymptomsFactor < ActiveRecord::Base
  belongs_to :symptom
  belongs_to :factor
  belongs_to :factor_group
  has_many :contents_symptoms_factors
  has_many :contents, :through => :contents_symptoms_factors

  attr_accessible :symptom, :symptom_id, :factor, :factor_id, :factor_group, :factor_group_id,
                  :doctor_call_worthy, :er_worthy

  validates :symptom, :factor, :factor_group, presence: true
  validates :factor_id, uniqueness: {scope: [:symptom_id, :factor_group_id]}
end
