class PlanOffering < ActiveRecord::Base
  belongs_to :plan
  belongs_to :offering
  attr_accessible :amount, :unlimited

  def self.with_offering_counts
    joins(:offering).group('offerings.id').count
  end
end
