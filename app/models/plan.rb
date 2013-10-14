class Plan < ActiveRecord::Base
  attr_accessible :monthly, :name

  has_many :plan_offerings
  has_many :offerings, :through => :plan_offerings

  def as_json options=nil
    {
      id: id,
      name: name,
      monthly: monthly,
      offerings: Offering.with_credits(plan_offerings.with_offering_counts)
    }
  end
end
