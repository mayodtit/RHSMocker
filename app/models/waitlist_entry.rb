class WaitlistEntry < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  TOKEN_CHARACTERS = ('a'..'z').to_a
  TOKEN_LENGTH = 5

  attr_accessible :email, :token, :invited_at, :claimed_at

  validates :email, presence: true, uniqueness: true

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
    event :invite do
      transition :waiting => :invited
    end

    event :claim do
      transition :invited => :claimed
    end

    state :invited do
      validates :token, :invited_at, presence: true
    end

    state :claimed do
      validates :claimed_at, presence: true
    end

    before_transition any => :invited do |entry, transition|
      entry.invited_at = Time.now
      entry.generate_token
    end

    before_transition any => :claimed do |entry, transition|
      entry.claimed_at = Time.now
      entry.token = nil
    end
  end
end
