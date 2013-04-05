class Factor < ActiveRecord::Base
  attr_accessible :name
  has_many :symptoms_factors
  has_many :symptoms, :through=>:symptoms_factors
end
