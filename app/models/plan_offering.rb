class PlanOffering < ActiveRecord::Base
  belongs_to :plan
  belongs_to :offering

  attr_accessible :plan, :plan_id, :offering, :offering_id, :amount, :unlimited

  validates :plan, :offering, :amount, presence: true
  validates :unlimited, :inclusion => {:in => [true, false]}
  validates :offering_id, :uniqueness => {:scope => :plan_id}

  def self.with_offering_counts
    joins(:offering).group('offerings.id').count
  end

  def add_credits!(user)
    if unlimited?
      user.credits.create!(:offering_id => offering_id, :unlimited => true)
    else
      amount.times do
        user.credits.create!(:offering_id => offering_id)
      end
    end
  end
end
