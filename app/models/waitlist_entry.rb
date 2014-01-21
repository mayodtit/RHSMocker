class WaitlistEntry < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  TOKEN_CHARACTERS = ('a'..'z').to_a
  TOKEN_LENGTH = 5

  belongs_to :creator, class_name: Member
  belongs_to :claimer, class_name: Member, inverse_of: :waitlist_entry
  belongs_to :feature_group

  attr_accessible :creator, :creator_id, :claimer, :claimer_id, :email, :token,
                  :state, :state_event, :invited_at, :claimed_at

  validates :email, presence: true, uniqueness: true
  validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}, allow_nil: true
  validates :creator, presence: true, if: lambda{|w| w.creator_id}
  validates :claimer, presence: true, if: lambda{|w| w.claimer_id}
  validates :feature_group, presence: true, if: lambda{|w| w.feature_group_id}

  def self.invited
    where(state: :invited)
  end

  def generate_token
    self.token = loop do
      new_token = (0...TOKEN_LENGTH).map{TOKEN_CHARACTERS.to_a[SecureRandom.random_number(TOKEN_CHARACTERS.length)]}.join
      break new_token unless WaitlistEntry.exists?(token: new_token)
    end
  end

  private

  def token_is_nil
    errors.add(:token, 'must be cleared') unless token.nil?
  end

  state_machine initial: :waiting do
    state :invited do
      validates :token, :invited_at, presence: true
    end

    state :claimed do
      validates :claimer, presence: true
      validates :claimed_at, presence: true
      validate :token_is_nil
    end

    event :invite do
      transition :waiting => :invited
    end

    event :claim do
      transition :invited => :claimed
    end

    before_transition any => :invited do |entry, transition|
      entry.invited_at = Time.now
      entry.generate_token
    end

    before_transition any => :claimed do |entry, transition|
      entry.claimed_at = Time.now
      entry.token = nil
    end

    after_transition any => :claimed do |entry, transition|
      entry.claimer.feature_groups << entry.feature_group if entry.feature_group
    end
  end
end
