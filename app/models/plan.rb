class Plan < ActiveRecord::Base
  belongs_to :plan_group
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

  def self.for_group_by_name(group_name)
    joins(:plan_group).where(:plan_group => {:name => group_name})
  end
end
