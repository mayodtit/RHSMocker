class Plan < ActiveRecord::Base
  belongs_to :plan_group
  attr_accessible :monthly, :name
end
