class Member < User
  authenticates_with_sorcery!

  has_many :user_roles, foreign_key: :user_id, inverse_of: :user
  has_many :roles, through: :user_roles

  has_many :user_agreements, foreign_key: :user_id, inverse_of: :user
  has_many :agreements, through: :user_agreements
  has_many :cards, :foreign_key => :user_id
  has_many :user_readings, :foreign_key => :user_id
  has_many :contents, :through => :user_readings
  has_many :initiated_consults, class_name: Consult, foreign_key: :initiator_id
  has_many :messages, :foreign_key => :user_id
  has_many :message_statuses, :foreign_key => :user_id

  has_many :subscriptions, :foreign_key => :user_id
  has_many :plans, :through => :subscriptions
  has_many :credits, :foreign_key => :user_id
  has_many :offerings, :through => :credits

  has_many :invitations

  has_many :user_feature_groups, :foreign_key => :user_id
  has_many :feature_groups, :through => :user_feature_groups
  has_one :waitlist_entry, foreign_key: :claimer_id,
                           inverse_of: :claimer,
                           autosave: true

  belongs_to :pha, class_name: 'Member'

  accepts_nested_attributes_for :user_agreements

  attr_accessible :install_id, :password, :password_confirmation,
                  :holds_phone_in, :invitation_token, :units,
                  :waitlist_entry, :user_agreements_attributes, :pha, :pha_id

  validates :pha, presence: true, if: lambda{|m| m.pha_id}
  validates :member_flag, inclusion: {in: [true]}
  validates :email, :uniqueness => {:message => 'account already exists.', :case_sensitive => false}, :allow_nil => true
  validates :password, :length => {:minimum => 8, :message => "must be 8 or more characters long"}, :confirmation => true, :if => :password
  validates :install_id, :uniqueness => true, :allow_nil => true
  validates :units, :inclusion => {:in => %w(US Metric)}
  validates :terms_of_service_and_privacy_policy, :acceptance => {:accept => true}, :if => lambda{|m| m.signed_up? || m.password}
  validate :owner_is_self

  before_validation :set_owner
  before_validation :set_member_flag
  before_create :set_auth_token # generate inital auth_token
  after_create :add_install_message
  after_create :add_new_member_content
  #after_save :update_cards_for_questions!

  def self.name_search(string)
    wildcard = "%#{string}%"
    where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", wildcard, wildcard, wildcard)
  end

  def has_role?(role)
    role_names.include?(role.to_s)
  end

  def add_role(role_name)
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
    has_role?(:pha) || has_role?(:pha_lead) || has_role?(:admin)
  end

  def pha_lead?
    has_role?(:pha_lead) || has_role?(:admin)
  end

  def care_provider?
    pha? || nurse?
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
    cards.create(resource: Content.explainer, priority: 30) if Content.explainer
    Question.new_member_questions.each do |q|
      cards.create!(resource: q)
    end
    true
  end

  def max_inbox_content?
    cards.inbox.select{|c| c.content_card?}.count > Card::MAX_CONTENT_PER_USER
  end

  def invite! invitation
    return if signed_up?
    update_attributes!(:invitation_token => invitation.token)
    UserMailer.invitation_email(self, invitation.member).deliver
  end

  def signed_up?
    crypted_password.present?
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
    find_or_create_by_email(:email => 'robot@getbetter.com',
                            :first_name => 'Clare',
                            :last_name => 'W',
                            :avatar_url_override => "http://i.imgur.com/eU3p9Hj.jpg")
  end

  def terms_of_service_and_privacy_policy
    return true unless Agreement.active
    user_agreements.map(&:agreement_id).include? Agreement.active.id
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
end
