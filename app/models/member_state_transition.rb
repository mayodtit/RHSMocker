class MemberStateTransition < ActiveRecord::Base
  belongs_to :member
  belongs_to :actor, class_name: 'Member'

  attr_accessible :member, :member_id, :actor, :actor_id,
                  :event, :from, :to, :created_at, :updated_at,
                  :free_trial_ends_at

  validates :member, :actor, presence: true
  validates :free_trial_ends_at, presence: true,
                                 if: ->(t){t.to.try(:to_sym) == :trial}

  def self.exists_for?(member, state)
    where(member_id: member.id, to: state).any?
  end

  def self.multiple_exist_for?(member, state)
    where(member_id: member.id, to: state).count > 1
  end
end
