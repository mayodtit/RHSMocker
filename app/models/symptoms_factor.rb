class SymptomsFactor < ActiveRecord::Base
  belongs_to :symptom
  belongs_to :factor
  belongs_to :factor_group
  has_and_belongs_to_many :contents
  attr_accessible :doctor_call_worthy, :er_worthy
end
