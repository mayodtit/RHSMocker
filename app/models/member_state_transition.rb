class MemberStateTransition < ActiveRecord::Base
  belongs_to :member

  attr_accessible :created_at, :event, :from, :to

  validates :member, presence: true
end
