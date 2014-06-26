class Member < User
  authenticates_with_sorcery!

  has_many :user_roles, foreign_key: :user_id, inverse_of: :user
  has_many :roles, through: :user_roles

  has_many :user_agreements, foreign_key: :user_id, inverse_of: :user
  has_many :agreements, through: :user_agreements
  has_many :cards, foreign_key: :user_id,
                   inverse_of: :user,
                   dependent: :destroy
  has_many :user_readings, :foreign_key => :user_id
  has_many :contents, :through => :user_readings
  has_many :initiated_consults, class_name: Consult, foreign_key: :initiator_id
  has_one :master_consult, class_name: 'Consult', foreign_key: :initiator_id, conditions: {master: true}
  has_many :messages, :foreign_key => :user_id
  has_many :message_statuses, :foreign_key => :user_id
  has_many :phone_calls, :foreign_key => :user_id
  has_many :scheduled_phone_calls, foreign_key: :user_id
  has_many :invitations
  has_many :user_feature_groups, foreign_key: :user_id, dependent: :destroy
  has_many :feature_groups, through: :user_feature_groups
  has_one :waitlist_entry, foreign_key: :claimer_id,
                           inverse_of: :claimer,
                           autosave: true
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

  has_one :owned_subscription, class_name: 'Subscription', foreign_key: :owner_id
  has_one :subscription_user, foreign_key: :user_id
  has_one :shared_subscription, through: :subscription_user, class_name: 'Subscription', source: :subscription
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
                  :waitlist_entry, :user_agreements_attributes, :pha, :pha_id,
                  :apns_token, :is_premium, :free_trial_ends_at, :last_contact_at,
                  :skip_agreement_validation, :signed_up_at, :subscription_ends_at,
                  :test_user, :marked_for_deletion, :onboarding_group, :onboarding_group_id,
                  :referral_code, :referral_code_id, :on_call, :owned_referral_code

  validates :pha, presence: true, if: lambda{|m| m.pha_id}
  validates :member_flag, inclusion: {in: [true]}
  validates :test_user, :marked_for_deletion, inclusion: {in: [true, false]}
  validates :email, :uniqueness => {:message => 'account already exists', :case_sensitive => false}, :allow_nil => true
  validates :password, :length => {:minimum => 8, :message => "must be 8 or more characters long"}, :confirmation => true, :if => :password
  validates :install_id, :uniqueness => true, :allow_nil => true
  validates :units, :inclusion => {:in => %w(US Metric)}
  validates :terms_of_service_and_privacy_policy, :acceptance => {:accept => true}, :if => lambda{|m| !skip_agreement_validation && (m.signed_up? || m.password) }
  validate :owner_is_self
  validates :apns_token, uniqueness: true, allow_nil: true
  validates :onboarding_group, presence: true, if: ->(m){m.onboarding_group_id}
  validates :referral_code, presence: true, if: ->(m){m.referral_code_id}

  before_validation :set_owner
  before_validation :set_member_flag
  before_validation :set_test_user
  before_validation :set_marked_for_deletion
  before_validation :set_signed_up_at
  before_validation :set_premium
  before_validation :set_free_trial_ends_at
  before_validation :convert_premium
  before_create :set_auth_token # generate inital auth_token
  after_create :add_install_message
  after_create :add_new_member_content
  after_create :add_owned_referral_code
  after_create :add_referral_card_job
  after_save :send_welcome_email
  after_save :send_free_trial_email
  after_save :send_free_trial_upgrade_email
  after_save :send_premium_email
  after_save :send_meet_your_pha_email
  after_save :notify_pha_of_new_member
  after_save :create_initial_master_consult_message
  after_save :alert_stakeholders_on_call_status

  scope :signed_up, -> { where('signed_up_at IS NOT NULL') }

  def self.name_search(string)
    wildcard = "%#{string}%"
    where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", wildcard, wildcard, wildcard)
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

  def login
    update_attribute :auth_token, Base64.urlsafe_encode64(SecureRandom.base64(36))
  end

  def logout
    update_attribute(:auth_token, nil)
  end

  def add_install_message
    if Content.install_message
      cards.create!(resource: Content.install_message,
                    state: :saved,
                    state_changed_at: Time.zone.now.iso8601)
    end
    true
  end

  def add_new_member_content
    cards.create(resource: CustomCard.swipe_explainer, priority: 100) if CustomCard.swipe_explainer
    cards.create(resource: Content.explainer, priority: 30) if Content.explainer
    Question.new_member_questions.each do |q|
      cards.create!(resource: q)
    end
    4.times do
      content = Content.next_for(self)
      cards.create(resource: content) if content
    end
    true
  end

  def add_owned_referral_code
    return if owned_referral_code
    create_owned_referral_code!(name: email)
  end

  def add_referral_card_job
    ReferralCardJob.create(id)
  end

  def send_welcome_email
    if newly_signed_up? && !free_trial? && !is_premium?
      Mails::WelcomeToBetterJob.create(id)
    end
  end

  def send_free_trial_email
    if newly_signed_up? && free_trial?
      Mails::WelcomeToBetterFreeTrialJob.create(id)
    end
  end

  def send_free_trial_upgrade_email
    if signed_up? && !newly_signed_up? && newly_free_trial?
      Mails::UpgradeToBetterFreeTrialJob.create(id)
    end
  end

  def send_premium_email
    if (!free_trial? && is_premium?) &&
       (free_trial_ends_at_changed? ||
        (signed_up? && newly_premium?) ||
        (is_premium? && newly_signed_up?))
      Mails::WelcomeToPremiumJob.create(id)
    end
  end

  def send_meet_your_pha_email
    if is_premium? && newly_assigned_pha?
      Mails::MeetYourPhaJob.create(id)
    end
  end

  def max_inbox_content?
    cards.inbox.select{|c| c.content_card?}.count > Card::MAX_CONTENT_PER_USER
  end

  def invite! invitation
    return if signed_up?
    update_attributes!(:invitation_token => invitation.token)

    # NOTE 5/8/2014: We only send emails to care providers because we are inviting influencers and
    # want invitations to Premium to be sent by a person.
    UserMailer.delay.invitation_email(self, invitation.member) if care_provider?
  end

  def hacky_simple_invite!
    return if signed_up?
    update_attributes!(invitation_token: Invitation.new.send(:generate_token))
    Mails::InvitationJob.create(id, Rails.application.routes.url_helpers.invite_url(invitation_token))
  end

  def signed_up?
    signed_up_at.present?
  end

  def member
    self
  end

  def self.create_from_user!(user)
    create!(email: user.email)
  end

  def pusher_id
    "RHS_#{Rails.env}_#{id}"
  end

  def self.robot
    find_or_create_by_email(:email => 'testphone+robot@getbetter.com',
                            :first_name => 'Clare',
                            :last_name => 'W',
                            :avatar_url_override => 'http://i.imgur.com/eU3p9Hj.jpg')
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

  def self.phas
    # less efficient than Role.find.users, but safer because ensures Member
    joins(:roles).where(roles: {name: :pha})
  end

  def self.phas_with_capacity
    phas.reject{|m| !m.pha_profile || m.pha_profile.max_capacity?}
  end

  def self.pha_counts
    group(:pha_id).where(is_premium: true)
                  .where('signed_up_at IS NOT NULL')
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

  def assign_pha!
    update_attributes!(pha: self.class.next_pha)
  end

  def add_premium_cards
    cards.build(resource: Content.premium, priority: 50) if Content.premium # fail silently
    cards.build(resource: CustomCard.onboarding, priority: 45) if CustomCard.onboarding # fail silently
  end

  def remove_premium_cards
    cards.where(resource_type: CustomCard, resource_id: CustomCard.onboarding.id).destroy_all if CustomCard.onboarding
    cards.where(resource_type: Content, resource_id: Content.premium.id).destroy_all if Content.premium
  end

  def notify_pha_of_new_member
    if (newly_assigned_pha? && signed_up?) || (newly_signed_up? && pha_id.present?)
      NewMemberTask.delay.create! member: self, title: 'New Premium Member', creator: Member.robot
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

  private

  def owner_is_self
    owner == self
  end

  def set_owner
    self.owner ||= self
  end

  def set_member_flag
    self.member_flag ||= true
  end

  def set_test_user
    self.test_user = false if test_user.nil?
    true
  end

  def set_marked_for_deletion
    self.marked_for_deletion = false if marked_for_deletion.nil?
    true
  end

  def set_signed_up_at
    if crypted_password.nil? && password.present?
      self.signed_up_at ||= Time.now
    end
  end

  def set_premium
    if newly_signed_up? && onboarding_group.try(:premium?)
      self.is_premium ||= true
    end
  end

  def set_free_trial_ends_at
    if newly_signed_up? && is_premium?
      self.free_trial_ends_at ||= onboarding_group.try(:free_trial_ends_at, signed_up_at)
    end
  end

  def convert_premium
    if newly_premium?
      add_premium_cards
      self.pha ||= self.class.next_pha
      master_consult || build_master_consult(subject: self,
                                             title: 'Direct messaging with your Better PHA',
                                             skip_tasks: true)
    elsif !is_premium? && is_premium_changed?
      remove_premium_cards
    end
  end

  def set_auth_token
    self.auth_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
  end

  def update_cards_for_questions!
    cards.for_resource(Question.find_by_view(:gender)).try(:saved!) if gender_changed?
    true
  end

  def role_names
    @role_names ||= roles.pluck(:name)
  end

  def skip_agreement_validation
    @skip_agreement_validation || false
  end

  def newly_assigned_pha?
    pha_id_changed? && pha_id.present?
  end

  def newly_signed_up?
    signed_up? && signed_up_at_changed?
  end

  def newly_premium?
    is_premium? && is_premium_changed?
  end

  def free_trial?
    free_trial_ends_at.try(:>, Time.now) || false
  end

  def newly_free_trial?
    free_trial? && free_trial_ends_at_changed?
  end

  def create_initial_master_consult_message
    return unless is_premium?
    return unless newly_signed_up?
    master_consult.try(:send_initial_message)
    true
  end
end
