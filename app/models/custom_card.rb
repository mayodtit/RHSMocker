class CustomCard < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :content
  has_many :cards, as: :resource
  serialize :card_actions, Array
  serialize :timeline_action, Hash

  attr_accessible :content, :content_id, :title, :raw_preview, :card_actions,
                  :timeline_actions, :priority, :unique_id, :has_custom_card,
                  :payment_card, :pha_card

  validates :title, :raw_preview, presence: true
  validates :has_custom_card, :payment_card, :pha_card, inclusion: {in: [true, false]}
  validates :unique_id, uniqueness: true, allow_blank: true

  before_validation :set_defaults, on: :create

  def self.onboarding
    @onboarding ||= find_by_unique_id('RHS-ONBOARDING')
  end

  def self.swipe_explainer
    @swipe_explainer ||= find_by_unique_id('RHS-SWIPE_EXPLAINER')
  end

  def self.referral
    @referral ||= find_by_unique_id('RHS-REFERRAL')
  end

  def self.meet_your_pha
    @meet_your_pha ||= find_by_unique_id('RHS-MEETYOURPHA')
  end

  def self.gender
    @gender ||= find_by_unique_id('RHS-GENDER')
  end

  def self.mayo_pilot
    @mayo_pilot ||= find_by_unique_id('RHS-MAYOPILOT')
  end

  private

  def set_defaults
    self.raw_preview = 'New card text for CustomCard' if raw_preview.blank?
    self.has_custom_card ||= false
    self.payment_card ||= false
    self.pha_card ||= false
    true
  end
end
