class MemberStateTransition < ActiveRecord::Base
  belongs_to :member

  attr_accessible :event, :from, :to, :created_at, :updated_at

  validates :member, presence: true

  def self.exists_for?(member, state)
    where(member_id: member.id, to: state).any?
  end

  def self.multiple_exist_for?(member, state)
    where(member_id: member.id, to: state).count > 1
  end
end
