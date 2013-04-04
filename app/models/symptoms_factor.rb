class SymptomsFactor < ActiveRecord::Base
  belongs_to :symptom
  belongs_to :factor
  belongs_to :factor_group
  has_many :contents_symptoms_factors
  has_many :contents, :through => :contents_symptoms_factors
  attr_accessible :doctor_call_worthy, :er_worthy

  def as_json options=nil
    {
      :id=>id,
      :name=>factor.name,
      :doctor_call_worthy=>doctor_call_worthy,
      :er_worthy=>er_worthy
    }
  end
end
