class Symptom < ActiveRecord::Base
  attr_accessible :name, :patient_type, :description
  has_many :symptoms_factors
  has_many :factors, :through=>:symptoms_factors
  has_and_belongs_to_many :contents

  validates :patient_type, :inclusion =>{
    :in=> %w(adult child),
    :message=>"%{value} is not valid. Only 'adult' or 'child' accepted'.",
    :allow_nil=>false }
end
