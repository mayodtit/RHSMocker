class PlanOffering < ActiveRecord::Base
  belongs_to :plan
  belongs_to :offering
  attr_accessible :amount, :unlimited
end
