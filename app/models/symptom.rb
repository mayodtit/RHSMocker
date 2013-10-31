class Symptom < ActiveRecord::Base
  attr_accessible :name, :patient_type, :description, :selfcare, :gender
  has_many :symptoms_factors
  has_many :factors, :through=>:symptoms_factors
  has_and_belongs_to_many :contents

  validates :patient_type, :inclusion =>{
    :in=> %w(adult child),
    :allow_nil=>false}

  validates :gender, :inclusion=> {
  	:in=> %w(M F), 
  	:allow_nil=>true}

end
