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

  accepts_nested_attributes_for :provider

  attr_accessible :name, :premium, :free_trial_days,
                  :absolute_free_trial_ends_at, :provider, :provider_id,
                  :mayo_pilot, :npi_number, :provider_attributes,
                  :pha, :pha_id

  validates :name, presence: true
  validates :provider, presence: true, if: ->(o){o.provider_id}
  validates :premium, inclusion: {in: [true, false]}
  validates :free_trial_days, numericality: {only_integer: true}
  validates :mayo_pilot, inclusion: {in: [true, false]}

  before_validation :set_defaults

  def free_trial_ends_at(time=nil)
    if !premium?
      nil
    elsif absolute_free_trial_ends_at
      absolute_free_trial_ends_at
    elsif free_trial_days > 0
      (time || Time.now).pacific.end_of_day + free_trial_days.days
    else
      nil
    end
  end

  def npi_number=(npi_number)
    if provider = User.find_by_npi_number(npi_number)
      self.provider = provider
    else
      self.provider_attributes = PermittedParams.new(ActionController::Parameters.new(user: provider_attributes(npi_number))).user
    end
  end

  private

  def set_defaults
    self.mayo_pilot ||= false
    true
  end

  def provider_attributes(npi_number)
    Search::Service.new.find(npi_number: npi_number)
  end
end
