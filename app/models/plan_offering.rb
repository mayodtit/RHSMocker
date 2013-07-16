class PlanOffering < ActiveRecord::Base
  belongs_to :plan
  belongs_to :offering

  attr_accessible :plan, :offering
  attr_accessible :amount, :unlimited, :plan_id, :offering_id

  def self.with_offering_counts
    joins(:offering).group('offerings.id').count
  end
end
