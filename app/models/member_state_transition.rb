class MemberStateTransition < ActiveRecord::Base
  belongs_to :member

  attr_accessible :event, :from, :to, :created_at, :updated_at

  validates :member, presence: true
end
