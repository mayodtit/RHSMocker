class Member < User
  authenticates_with_sorcery!
  has_many :sessions, dependent: :destroy
  has_many :discounts, foreign_key: :user_id
  has_many :user_roles, foreign_key: :user_id, inverse_of: :user
  has_many :roles, through: :user_roles
  has_many :user_agreements, foreign_key: :user_id, inverse_of: :user
  has_many :agreements, through: :user_agreements
  has_many :cards, foreign_key: :user_id,
                   inverse_of: :user,
                   dependent: :destroy
  has_many :user_readings, foreign_key: :user_id
  has_many :contents, through: :user_readings
  has_many :initiated_consults, class_name: 'Consult',
                                foreign_key: :initiator_id
  has_one :master_consult, class_name: 'Consult',
                           foreign_key: :initiator_id,
                           conditions: {master: true}
  has_many :messages, foreign_key: :user_id, dependent: :destroy
  has_many :message_statuses, foreign_key: :user_id
  has_many :phone_calls, foreign_key: :user_id
  has_many :scheduled_phone_calls, foreign_key: :user_id
  has_many :owned_scheduled_phone_calls, class_name: 'ScheduledPhoneCall',
                                         foreign_key: :owner_id
  has_many :invitations
  has_many :user_feature_groups, foreign_key: :user_id, dependent: :destroy
  has_many :feature_groups, through: :user_feature_groups
  has_one :pha_profile, foreign_key: :user_id, inverse_of: :user
  has_one :owned_referral_code, class_name: 'ReferralCode',
                                foreign_key: :user_id,
                                inverse_of: :user
  belongs_to :pha, class_name: 'Member', inverse_of: :owned_members
  #TODO - careful, there is a User::owned_users that does something different
  has_many :owned_members, class_name: 'Member',
                           foreign_key: :pha_id,
                           inverse_of: :pha
  has_many :user_programs, foreign_key: :user_id, dependent: :destroy
  has_many :programs, through: :user_programs
  has_one :subscription, class_name: 'Subscription',
                         foreign_key: :owner_id
  has_one :subscription_user, foreign_key: :user_id
  has_one :shared_subscription, through: :subscription_user,
                                class_name: 'Subscription',
                                source: :subscription
  has_many :tasks, class_name: 'Task', conditions: ['type NOT IN (?, ?, ?)', 'MessageTask', 'PhoneCallTask', 'ViewTaskTask']
  has_many :request_tasks, class_name: 'Task', conditions: {type: %w(UserRequestTask ParsedNurselineRecordTask)}
  has_many :service_tasks, class_name: 'MemberTask',
                           conditions: proc{ {service_type_id: ServiceType.non_engagement_ids} }
  has_many :services
  has_many :user_images, foreign_key: :user_id,
                         inverse_of: :user,
                         dependent: :destroy
  belongs_to :onboarding_group, inverse_of: :users
  belongs_to :referral_code, inverse_of: :users
  has_many :user_requests, foreign_key: :user_id
  has_many :outbound_scheduled_communications, class_name: 'ScheduledCommunication',
                                               foreign_key: :sender_id,
                                               inverse_of: :sender
  has_many :inbound_scheduled_communications, class_name: 'ScheduledCommunication',
                                              foreign_key: :recipient_id,
                                              inverse_of: :recipient
  has_many :inbound_scheduled_messages, class_name: 'ScheduledMessage',
                                        foreign_key: :recipient_id,
                                        inverse_of: :recipient
  has_many :referring_scheduled_communications, class_name: 'ScheduledCommunication',
                                                as: :reference
  accepts_nested_attributes_for :user_agreements
  attr_accessor :skip_agreement_validation
  attr_accessor :payment_token
  belongs_to :nux_answer
  belongs_to :impersonated_user, class_name: 'Member'
  has_one :enrollment, foreign_key: :user_id, inverse_of: :user, autosave: true

  attr_accessible :password, :password_confirmation,
                  :invitation_token, :units,
                  :user_agreements_attributes, :pha, :pha_id,
                  :is_premium, :free_trial_ends_at,
                  :last_contact_at,
                  :skip_agreement_validation, :signed_up_at,
                  :subscription_ends_at,
                  :onboarding_group, :onboarding_group_id,
                  :referral_code, :referral_code_id, :on_call,
                  :owned_referral_code,
                  :status, :status_event,
                  :nux_answer_id, :nux_answer, :time_zone,
                  :cached_notifications_enabled, :email_confirmed,
                  :email_confirmation_token, :advertiser_id,
                  :advertiser_media_source, :advertiser_campaign,
                  :impersonated_user, :impersonated_user_id,
                  :enrollment, :payment_token, :coupon_count

  validates :signed_up_at, presence: true, if: ->(m){m.signed_up?}
  validates :pha, presence: true, if: ->(m){m.pha_id}
  validates :member_flag, inclusion: {in: [true]}
  validates :email, uniqueness: {message: 'account already exists',
                                 case_sensitive: false},
                    allow_nil: true
  validates :password, length: {minimum: 8,
                                message: "must be 8 or more characters long"},
                       confirmation: true,
                       if: :password
  validates :units, inclusion: {in: %w(US Metric)}
  validates :terms_of_service_and_privacy_policy, acceptance: {accept: true},
                                                  if: ->(m){!skip_agreement_validation && (m.signed_up? || m.password)}
  validates :onboarding_group, presence: true, if: ->(m){m.onboarding_group_id}
  validates :referral_code, presence: true, if: ->(m){m.referral_code_id}
  validates :nux_answer, presence: true, if: -> (m) { m.nux_answer_id }
  validates :email_confirmation_token, presence: true, unless: ->(m){m.email_confirmed?}

  before_validation :set_member_flag
  before_validation :set_default_email_confirmed, on: :create
  before_validation :set_email_confirmation_token, unless: ->(m){m.email_confirmed?}
  before_validation :set_signed_up_at, if: ->(m){m.signed_up? && m.status_changed?}
  before_validation :set_free_trial_ends_at, if: ->(m){m.status?(:trial) && m.status_changed?}
  before_validation :unset_free_trial_ends_at
  before_validation :set_subscription_ends_at, if: ->(m){m.status?(:premium) && m.status_changed?}
  before_validation :unset_subscription_ends_at
  before_validation :set_invitation_token
  before_validation :unset_invitation_token
  before_validation :set_pha, if: ->(m){m.signed_up? && m.status_changed?}
  before_validation :set_master_consult, if: ->(m){m.signed_up? && m.status_changed?}
  after_create :add_new_member_content
  after_create :add_owned_referral_code
  after_create :add_onboarding_group_provider
  after_create :add_onboarding_group_cards
  after_create :add_onboarding_group_programs
  after_save :alert_stakeholders_on_call_status
  after_save :update_referring_scheduled_communications, if: ->(m){m.free_trial_ends_at_changed?}

  SIGNED_UP_STATES = %i(free trial premium chamath)
  def self.signed_up
    where(status: SIGNED_UP_STATES)
  end

  SIGNED_UP_CONSUMER_STATES = %i(free trial premium)
  def self.signed_up_consumer
    where(status: SIGNED_UP_CONSUMER_STATES)
  end

  PREMIUM_STATES = %i(trial premium chamath)
  def self.premium_states
    where(status: PREMIUM_STATES)
  end

  def self.with_request_or_service_task
    includes(:request_tasks, :service_tasks)
    .where('tasks.id IS NOT NULL OR service_tasks_users.id IS NOT NULL')
  end

  def self.with_completed_service_task
    includes(:service_tasks)
    .where(tasks: {state: :completed})
    .where('tasks.id IS NOT NULL')
  end

  def self.name_search(string)
    wildcard = "%#{string}%"
    where("users.first_name LIKE ? OR users.last_name LIKE ? OR users.email LIKE ?", wildcard, wildcard, wildcard)
  end

  def self.create_from_user!(user, actor)
    create!(email: user.email, actor_id: actor.id)
  end

  def self.robot
    find_or_create_by_email(email: 'testphone+robot@getbetter.com',
                            first_name: 'Clare',
                            last_name: 'W',
                            avatar_url_override: 'http://i.imgur.com/eU3p9Hj.jpg')
  end

  def self.geoff
    find_or_create_by_email(email: 'geoff@getbetter.com', first_name: 'Geoff', last_name: 'Clapp').tap do |m|
      m.add_role :pha unless m.pha?
    end
  end

  def self.phas
    # less efficient than Role.find.users, but safer because ensures Member
    joins(:roles).where(roles: {name: :pha})
  end

  def self.phas_with_profile
    phas.joins(:pha_profile)
  end

  def needs_agreement?
    !terms_of_service_and_privacy_policy
  end

  def has_role?(role)
    role_names.include?(role.to_s)
  end

  def add_role(role_name)
    return if has_role? role_name

    role = Role.where(name: role_name).first_or_create!
    roles << role
    @role_names << role.name.to_s if @role_names
  end

  def admin?
    has_role?(:admin)
  end

  def nurse?
    has_role?(:nurse)
  end

  def pha?
    has_role?(:pha) || has_role?(:pha_lead)
  end

  def pha_lead?
    has_role?(:pha_lead)
  end

  def care_provider?
    pha? || nurse?
  end

  def on_call?
    nurse? || read_attribute(:on_call)
  end

  def is_premium?
    status?(:trial) || status?(:premium) || status?(:chamath)
  end
  alias_method :is_premium, :is_premium?

  def is_premium=(new_value)
    return if is_premium? == new_value
    if new_value && free_trial_ends_at.present?
      self.status_event = :grant_free_trial
    elsif new_value
      self.status_event = :upgrade
    else
      self.status_event = :downgrade
    end
  end

  def signed_up?
    is_premium? || status?(:free)
  end

  def has_upgraded?
    MemberStateTransition.where(member_id: id).where(to: PREMIUM_STATES).exists?
  end

  def new_user?
    status?(:free) && !has_upgraded?
  end

  def invite! invitation
    return if signed_up?
    update_attributes!(invitation_token: invitation.token)

    # NOTE 5/8/2014: We only send emails to care providers because we are inviting influencers and
    # want invitations to Premium to be sent by a person.
    UserMailer.delay.invitation_email(self, invitation.member) if care_provider?
  end

  def hacky_simple_invite!
    return if signed_up?
    update_attributes!(invitation_token: Invitation.new.send(:generate_token))
    Mails::InvitationJob.create(id, Rails.application.routes.url_helpers.invite_url(invitation_token))
  end

  def member
    self
  end

  def terms_of_service_and_privacy_policy
    return true unless Agreement.active
    user_agreements.map(&:agreement_id).include? Agreement.active.id
  end

  def alert_stakeholders_on_call_status
    if pha? && on_call_changed? && Role.pha.on_call?
      num_phas_on_call = Role.pha.users.where(on_call: true).count
      body = nil

      if num_phas_on_call == 1 && on_call? # Only alert when first PHA starts triaging
        body = "OK: PHAs are triaging."
      elsif num_phas_on_call == 0
        body = "ALERT: No PHAs triaging!"
      end

      if body
        Role.pha_stakeholders.each do |s|
          TwilioModule.message s.work_phone_number, body
        end
      end
    end
  end

  def confirm_email!
    update_attributes!(email_confirmed: true,
                       email_confirmation_token: nil)
  end

  def initial_state
    if enrollment.present? && payment_token.present?
      :premium
    elsif password.present? || crypted_password.present?
      next_state
    else
      :invited
    end
  end

  def next_state
    if onboarding_group.try(:premium?) &&
       onboarding_group.try(:free_trial_ends_at)
      :trial
    elsif onboarding_group.try(:premium?)
      :premium
    else
      :free
    end
  end

  def smackdown!
    downgrade!
    mt = MessageTemplate.find_by_name 'TOS Violation'
    mt.create_message(Member.robot, master_consult, false, true, true) if mt
  end

  protected

  def free_trial_ends_at_is_nil
    errors.add(:free_trial_ends_at, 'must be nil') unless free_trial_ends_at.nil?
  end

  private

  state_machine :status, initial: ->(m){m.initial_state} do
    store_audit_trail to: 'MemberStateTransition', context_to_log: %i(actor_id free_trial_ends_at)
    state :invited do
      validates :invitation_token, presence: true
    end

    state :trial do
      validates :free_trial_ends_at, presence: true
    end

    state all - %i(invited trial) do
      validate {|member| member.free_trial_ends_at_is_nil}
    end

    event :sign_up do
      transition :invited => :premium, if: ->(m){m.next_state == :premium}
      transition :invited => :trial, if: ->(m){m.next_state == :trial}
      transition :invited => :free
    end

    event :upgrade do
      transition %i(free trial) => :premium
    end

    event :downgrade do
      transition any - :free => :free
    end

    event :grant_free_trial do
      transition %i(trial free) => :trial
    end

    event :chamathify do
      transition any - :chamath => :chamath
    end

    event :hold do
      transition :invited => :held
    end

    before_transition :invited => %i(free trial premium chamath) do |member, transition|
      member.email_confirmed = true
      member.email_confirmation_token = nil
    end

    after_transition any => %i(premium chamath) do |member, transition|
      UpgradeTask.create(title: 'Member upgraded!',
                         creator: Member.robot,
                         member: member,
                         due_at: Time.now)
    end

    after_transition %i(premium chamath) => :free do |member, transition|
      member.tasks.open_state.each do |task|
        task.reason_abandoned = "member_downgraded_canceled"
        task.abandoner = Member.robot
        task.reason = "member_downgraded_canceled"
        task.abandon!
      end
    end

    after_transition %i(premium chamath) => :free do |member, transition|
      DestroyStripeSubscriptionService.new(member, :downgrade).call if member.stripe_customer_id
    end
  end

  def set_signed_up_at
    self.signed_up_at ||= Time.now
  end

  def set_free_trial_ends_at
    self.free_trial_ends_at ||= onboarding_group.try(:free_trial_ends_at, signed_up_at)
  end

  def unset_free_trial_ends_at
    return if invited? || trial?
    self.free_trial_ends_at = nil if free_trial_ends_at
  end

  def set_subscription_ends_at
    self.subscription_ends_at ||= onboarding_group.try(:subscription_ends_at, signed_up_at)
  end

  def unset_subscription_ends_at
    return if premium?
    self.subscription_ends_at = nil if subscription_ends_at
  end

  def set_member_flag
    self.member_flag ||= true
  end

  def set_invitation_token
    return unless invited?
    self.invitation_token ||= loop do
      new_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_token unless self.class.exists?(invitation_token: new_token)
    end
  end

  def unset_invitation_token
    return if invited?
    self.invitation_token = nil if invitation_token
  end

  def set_default_email_confirmed
    self.email_confirmed = false if email_confirmed.nil?
    true
  end

  def set_email_confirmation_token
    self.email_confirmation_token ||= loop do
      new_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_token unless self.class.exists?(email_confirmation_token: new_token)
    end
  end

  def set_pha
    if onboarding_group.try(:pha)
      self.pha ||= onboarding_group.pha
    else
      next_pha_profile = if onboarding_group.try(:mayo_pilot?)
                           PhaProfile.next_pha_profile(true)
                         else
                           PhaProfile.next_pha_profile(false, nux_answer)
                         end
      self.pha ||= next_pha_profile.try(:user)
    end
    true
  end

  def set_master_consult
    master_consult || build_master_consult(subject: self,
                                           title: 'Direct messaging with your Better PHA',
                                           skip_tasks: true)
  end

  def add_new_member_content
    if onboarding_group.try(:mayo_pilot?)
      cards.create(resource: Content.mayo_pilot, priority: 30) if Content.mayo_pilot
    end
    cards.create(resource: CustomCard.gender, priority: 20) if CustomCard.gender
    if @cold_weather_content = Content.find_by_document_id('HQ01681')
      cards.create(resource: @cold_weather_content, priority: 1)
    end
    if @happiness_content = Content.find_by_document_id('MY01357')
      cards.create(resource: @happiness_content, priority: 1)
    end
    cards.create(resource: CustomCard.swipe_explainer, priority: 0) if CustomCard.swipe_explainer
  end

  def add_owned_referral_code
    return if owned_referral_code
    create_owned_referral_code!(name: email)
  end

  def add_onboarding_group_provider
    if onboarding_group.try(:provider)
      associations.create(associate: onboarding_group.provider,
                          association_type_id: AssociationType.hcp_default_id,
                          creator: self)
    end
  end

  def add_onboarding_group_cards
    (onboarding_group.try(:onboarding_group_cards) || []).each do |card|
      cards.create(resource: card.resource, priority: card.priority)
    end
  end

  def add_onboarding_group_programs
    (onboarding_group.try(:programs) || []).each do |program|
      user_programs.create(program: program, subject: self)
    end
  end

  def role_names
    @role_names ||= roles.pluck(:name)
  end

  def skip_agreement_validation
    @skip_agreement_validation || false
  end

  def update_referring_scheduled_communications
    if free_trial_ends_at.nil?
      referring_scheduled_communications.destroy_all
    else
      referring_scheduled_communications.each do |rsc|
        rsc.update_publish_at_from_calculation!
      end
    end
  end
end
