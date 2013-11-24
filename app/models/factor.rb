class Factor < ActiveRecord::Base
  has_many :symptoms_factors
  has_many :symptoms, through: :symptoms_factors

  attr_accessible :name

  validates :name, presence: true
end
