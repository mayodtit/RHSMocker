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

  def self.status_counts(time=Time.now)
    where(id: most_recent_ids_per_user(time))
    .group('member_state_transitions.to')
    .count
  end

  def self.most_recent_ids_per_user(time=Time.now)
    where('created_at < ?', time)
    .select('MAX(id) AS id')
    .group(:member_id)
    .map(&:id)
  end
end
