class Symptom < ActiveRecord::Base
  attr_accessible :name
  has_many :symptoms_factors
  has_many :factors, :through=>:symptoms_factors
  has_and_belongs_to_many :contents
end
