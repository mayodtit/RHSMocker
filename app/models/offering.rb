class Offering < ActiveRecord::Base
  has_many :plan_offerings
  has_many :plans, :through => :plan_offerings
  has_many :credits
  has_many :users, :through => :credits

  attr_accessible :name

  validates :name, presence: true, uniqueness: true
end
