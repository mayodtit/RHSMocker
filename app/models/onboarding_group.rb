class OnboardingGroup < ActiveRecord::Base
  has_many :users, class_name: 'Member',
                   inverse_of: :onboarding_group,
                   dependent: :nullify
  has_many :referral_codes, dependent: :nullify
  belongs_to :provider, class_name: 'User'
  has_many :onboarding_group_cards
  has_many :onboarding_group_programs
  has_many :programs, through: :onboarding_group_programs
  belongs_to :pha, class_name: 'Member'
  belongs_to :trial_nux_story, class_name: 'NuxStory'
  belongs_to :welcome_message_template, class_name: 'MessageTemplate'
  has_many :onboarding_group_candidates, inverse_of: :onboarding_group
  has_many :onboarding_group_suggested_service_templates, inverse_of: :onboarding_group
  has_many :suggested_service_templates, through: :onboarding_group_suggested_service_templates

  accepts_nested_attributes_for :provider

  attr_accessible :name, :premium, :free_trial_days,
                  :absolute_free_trial_ends_at, :provider, :provider_id,
                  :mayo_pilot, :npi_number, :provider_attributes,
                  :pha, :pha_id, :trial_nux_story,
                  :trial_nux_story_id, :stripe_coupon_code,
                  :absolute_subscription_ends_at, :subscription_days,
                  :skip_credit_card, :skip_automated_communications,
                  :skip_emails, :welcome_email_template, :welcome_email_template_id,
                  :welcome_message_template, :welcome_message_template_id,
                  :header_asset, :header_asset_url, :remote_header_asset_url,
                  :background_asset, :background_asset_url, :remote_background_asset_url,
                  :custom_welcome

  validates :name, presence: true
  validates :provider, presence: true, if: ->(o){o.provider_id}
  validates :premium, inclusion: {in: [true, false]}
  validates :free_trial_days, numericality: {only_integer: true}
  validates :subscription_days, numericality: {only_integer: true}
  validates :mayo_pilot, inclusion: {in: [true, false]}
  validates :skip_credit_card, inclusion: {in: [true, false]}
  validates :trial_nux_story, presence: true, if: ->(o){o.trial_nux_story_id}
  validates :skip_automated_communications, inclusion: {in: [true, false]}
  validates :skip_emails, inclusion: {in: [true, false]}

  before_validation :set_defaults

  mount_uploader :header_asset, OnboardingGroupHeaderAssetUploader
  mount_uploader :background_asset, OnboardingGroupBackgroundAssetUploader

  def header_asset_url
    header_asset.url
  end

  def background_asset_url
    background_asset.url
  end

  def free_trial_ends_at(time=nil)
    if !premium?
      nil
    elsif free_trial_days > 0 && absolute_free_trial_ends_at
      free_trial_days_from_now_or_absolute_free_trial_ends_at(time)
    elsif absolute_free_trial_ends_at
      absolute_free_trial_ends_at
    elsif free_trial_days > 0
      free_trial_days_from_now(time)
    else
      nil
    end
  end

  def free_trial_days_from_now_or_absolute_free_trial_ends_at(time)
    if free_trial_days_from_now(time) > absolute_free_trial_ends_at
      absolute_free_trial_ends_at
    else
      free_trial_days_from_now(time)
    end
  end

  def free_trial_days_from_now(time)
    (time || Time.now).pacific.end_of_day + free_trial_days.days
  end

  def subscription_ends_at(time=nil)
    if !premium?
      nil
    elsif subscription_days > 0 && absolute_subscription_ends_at
      subscription_days_from_now_or_absolute_subscription_ends_at(time)
    elsif absolute_subscription_ends_at
      absolute_subscription_ends_at
    elsif subscription_days > 0
      subscription_days_from_now(time)
    else
      nil
    end
  end

  def subscription_days_from_now_or_absolute_subscription_ends_at(time)
    if subscription_days_from_now(time) > absolute_subscription_ends_at
      absolute_subscription_ends_at
    else
      subscription_days_from_now(time)
    end
  end

  def subscription_days_from_now(time)
    (time || Time.now).pacific.end_of_day + subscription_days.days
  end

  def npi_number=(npi_number)
    if provider = User.find_by_npi_number(npi_number)
      self.provider = provider
    else
      self.provider_attributes = PermittedParams.new(ActionController::Parameters.new(user: provider_attributes(npi_number))).user
    end
  end

  def onboarding_customization?
    background_asset_url && header_asset_url
  end

  def onboarding_custom_welcome?
    background_asset_url && header_asset_url && custom_welcome
  end

  private

  def set_defaults
    self.mayo_pilot ||= false
    true
  end

  def provider_attributes(npi_number)
    Search::Service.new.find(npi_number: npi_number)
  end

  def add_content
    #cards.create(resource: Content.mayo_pilot, priority: 30) if (self.try(:mayo_pilot?)) && (Content.mayo_pilot)
  end

end
