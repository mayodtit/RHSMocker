class Factor < ActiveRecord::Base
  has_many :symptoms_factors
  has_many :symptoms, through: :symptoms_factors

  attr_accessible :name, :gender

  validates :name, presence: true
  validates :gender, inclusion: {in: %w(M F)}, allow_nil: true
end
