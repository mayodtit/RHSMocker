class Member < User
  authenticates_with_sorcery!
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
  has_many :messages, foreign_key: :user_id
  has_many :message_statuses, foreign_key: :user_id
  has_many :phone_calls, foreign_key: :user_id
  has_many :scheduled_phone_calls, foreign_key: :user_id
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
  has_one :owned_subscription, class_name: 'Subscription',
                               foreign_key: :owner_id
  has_one :subscription_user, foreign_key: :user_id
  has_one :shared_subscription, through: :subscription_user,
                                class_name: 'Subscription',
                                source: :subscription
  has_many :tasks, class_name: 'MemberTask'
  has_many :services
  has_many :user_images, foreign_key: :user_id,
                         inverse_of: :user,
                         dependent: :destroy
  belongs_to :onboarding_group, inverse_of: :users
  belongs_to :referral_code, inverse_of: :users
  has_many :user_requests, foreign_key: :user_id
  accepts_nested_attributes_for :user_agreements
  attr_accessor :skip_agreement_validation

  attr_accessible :install_id, :password, :password_confirmation,
                  :holds_phone_in, :invitation_token, :units,
                  :user_agreements_attributes, :pha, :pha_id,
                  :apns_token, :is_premium, :free_trial_ends_at,
                  :last_contact_at,
                  :skip_agreement_validation, :signed_up_at,
                  :subscription_ends_at,
                  :onboarding_group, :onboarding_group_id,
                  :referral_code, :referral_code_id, :on_call,
                  :owned_referral_code,
                  :status, :status_event

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
  validates :install_id, uniqueness: true, allow_nil: true
  validates :units, inclusion: {in: %w(US Metric)}
  validates :terms_of_service_and_privacy_policy, acceptance: {accept: true},
                                                  if: ->(m){!skip_agreement_validation && (m.signed_up? || m.password)}
  validate :owner_is_self
  validates :apns_token, uniqueness: true, allow_nil: true
  validates :onboarding_group, presence: true, if: ->(m){m.onboarding_group_id}
  validates :referral_code, presence: true, if: ->(m){m.referral_code_id}

  before_validation :set_owner
  before_validation :set_member_flag
  before_validation :set_signed_up_at, if: ->(m){m.signed_up?}
  before_validation :set_free_trial_ends_at, if: ->(m){m.status?(:trial)}
  before_validation :set_invitation_token, if: ->(m){m.status?(:invited)}
  before_validation :unset_invitation_token, if: ->(m){m.is_premium?}
  before_validation :set_pha, if: ->(m){m.is_premium?}
  before_validation :set_master_consult, if: ->(m){m.is_premium?}
  before_create :set_auth_token # generate inital auth_token
  after_create :add_new_member_content
  after_create :add_owned_referral_code
  after_save :add_automated_onboarding_message_workflow, if: ->(m){m.status?(:trial)}
  after_save :send_state_emails
  after_save :notify_pha_of_new_member, if: ->(m){m.pha_id && m.pha_id_changed?}
  after_save :alert_stakeholders_on_call_status

  SIGNED_UP_STATES = %i(free trial premium chamath)
  def self.signed_up
    where(status: SIGNED_UP_STATES)
  end

  PREMIUM_STATES = %i(trial premium chamath)
  def self.premium_states
    where(status: PREMIUM_STATES)
  end

  def self.name_search(string)
    wildcard = "%#{string}%"
    where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", wildcard, wildcard, wildcard)
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

  def self.phas
    # less efficient than Role.find.users, but safer because ensures Member
    joins(:roles).where(roles: {name: :pha})
  end

  def self.phas_with_capacity
    phas.reject{|m| !m.pha_profile || m.pha_profile.max_capacity?}
  end

  def self.pha_counts
    group(:pha_id).where(status: PREMIUM_STATES)
                  .where(pha_id: phas_with_capacity.map(&:id))
                  .count
                  .tap do |hash|
      hash.default = 0
    end
  end

  def self.next_pha
    current_counts = pha_counts
    min_count = current_counts.values.min || 0
    phas_with_capacity.inject(nil) do |selected, current|
      if current_counts[current.id] <= min_count
        selected = current
        min_count = current_counts[current.id]
      end
      selected
    end
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

  def engaged?
    tasks.joins(:service_type).where(service_types: {bucket: ['wellness', 'care coordination', 'insurance', 'other']}).count > 0 ||
    messages.count > 0
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

  def login
    update_attribute :auth_token, Base64.urlsafe_encode64(SecureRandom.base64(36))
  end

  def logout
    update_attribute(:auth_token, nil)
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

  def store_apns_token!(token)
    if apns_token != token
      transaction do
        Member.where(apns_token: token).update_all(apns_token: nil)
        update_attributes!(apns_token: token)
      end
    end
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

  def initial_state
    if password.present? || crypted_password.present?
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

  private

  state_machine :status, initial: ->(m){m.initial_state} do
    store_audit_trail to: 'MemberStateTransition', context_to_log: %i(actor_id free_trial_ends_at)
    state :invited do
      validates :invitation_token, presence: true
    end

    state :trial do
      validates :free_trial_ends_at, presence: true
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
      transition any => :free
    end

    event :grant_free_trial do
      transition :free => :trial
    end

    event :chamathify do
      transition any => :chamath
    end
  end

  def owner_is_self
    owner == self
  end

  def set_owner
    self.owner ||= self
  end

  def set_signed_up_at
    self.signed_up_at ||= Time.now
  end

  def set_free_trial_ends_at
    self.free_trial_ends_at ||= onboarding_group.try(:free_trial_ends_at, signed_up_at)
  end

  def set_member_flag
    self.member_flag ||= true
  end

  def set_invitation_token
    self.invitation_token ||= loop do
      new_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_token unless self.class.exists?(invitation_token: new_token)
    end
  end

  def unset_invitation_token
    self.invitation_token = nil if invitation_token
  end

  def set_pha
    self.pha ||= self.class.next_pha
  end

  def set_master_consult
    master_consult || build_master_consult(subject: self,
                                           title: 'Direct messaging with your Better PHA',
                                           skip_tasks: true)
  end

  def set_auth_token
    self.auth_token ||= loop do
      new_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_token unless self.class.exists?(auth_token: new_token)
    end
  end

  def add_new_member_content
    cards.create(resource: Content.free_trial, priority: 30) if Content.free_trial
    cards.create(resource: CustomCard.meet_your_pha, priority: 25) if CustomCard.meet_your_pha && pha.present?
    cards.create(resource: CustomCard.gender, priority: 20) if CustomCard.gender
    if @sunscreen_content = Content.find_by_document_id('MY01350')
      cards.create(resource: @sunscreen_content)
    end
    if @happiness_content = Content.find_by_document_id('MY01357')
      cards.create(resource: @happiness_content)
    end
    cards.create(resource: CustomCard.swipe_explainer) if CustomCard.swipe_explainer
  end

  def add_owned_referral_code
    return if owned_referral_code
    create_owned_referral_code!(name: email)
  end

  def add_automated_onboarding_message_workflow
    if Metadata.automated_onboarding? && master_consult.try(:scheduled_messages).try(:empty?)
      MessageWorkflow.automated_onboarding.try(:add_to_member, self)
    end
  end

  def send_state_emails
    if status?(:trial) &&
       status_changed? &&
       !MemberStateTransition.multiple_exist_for?(member, :trial) &&
       !@emails_sent
      Mails::MeetYourPhaJob.create(member.id)
      @emails_sent = true
    end
  end

  def notify_pha_of_new_member
    if pha_id
      NewMemberTask.delay.create!(member: self,
                                  title: 'New Premium Member',
                                  creator: Member.robot)
    end
  end

  def role_names
    @role_names ||= roles.pluck(:name)
  end

  def skip_agreement_validation
    @skip_agreement_validation || false
  end
end
