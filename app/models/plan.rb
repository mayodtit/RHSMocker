class Plan < ActiveRecord::Base
  belongs_to :plan_group
  attr_accessible :monthly, :name

  def self.for_group_by_name(group_name)
    joins(:plan_group).where(:plan_group => {:name => group_name})
  end
end
