class Member < User
  authenticates_with_sorcery!

  has_many :user_agreements, :foreign_key => :user_id
  has_many :agreements, :through => :user_agreements
  has_many :cards, :foreign_key => :user_id
  has_many :user_readings, :foreign_key => :user_id
  has_many :contents, :through => :user_readings
  has_many :messages, :foreign_key => :user_id
  has_many :consult_users, :foreign_key => :user_id
  has_many :consults, :through => :consult_users
  has_many :message_statuses, :foreign_key => :user_id
  has_many :locations, :foreign_key => :user_id

  has_many :subscriptions, :foreign_key => :user_id
  has_many :plans, :through => :subscriptions
  has_many :credits, :foreign_key => :user_id
  has_many :offerings, :through => :credits

  has_many :invitations

  has_many :user_feature_groups, :foreign_key => :user_id
  has_many :feature_groups, :through => :user_feature_groups

  accepts_nested_attributes_for :user_agreements

  attr_accessible :install_id, :password, :password_confirmation,
                  :holds_phone_in, :invitation_token, :units, :agreement_params

  validates :email, :uniqueness => {:message => 'account already exists', :case_sensitive => false}, :allow_nil => true
  validates :password, :length => {:minimum => 8, :message => "must be 8 or more characters long"}, :confirmation => true, :if => :password
  validates :install_id, :uniqueness => true, :allow_nil => true
  validates :phone, :length => {:in => 7..17, :message => 'must be between 7 and 17 digits'}, :allow_blank => true
  validates :units, :inclusion => {:in => %w(US Metric)}
  validates :terms_of_service_and_privacy_policy, :acceptance => {:accept => true}, :on => :create, :if => lambda{|m| m.email.present?}

  after_create :login # generate inital auth_token
  after_create :add_install_message
  after_create :add_new_member_content
  after_create :send_welcome_message, :if => lambda{|m| m.email.present?}

  BASE_OPTIONS = User::BASE_OPTIONS.merge(:only => [:holds_phone_in, :install_id,
                                                    :phone, :units],
                                          :methods => [:pusher_id]) do |k, v1, v2|
                   v1.is_a?(Array) ? v1 + v2 : [v1] + v2
                 end

  def serializable_hash options=nil
    options ||= BASE_OPTIONS
    super(options)
  end

  # rolify only adds class methods to the base class, cast first to call
  def has_role?(role)
    becomes(User).has_role?(role)
  end

  def add_role(role)
    becomes(User).add_role(role)
  end

  def admin?
    has_role? :admin
  end

  def hcp?
    has_role?(:hcp) || has_role?(:admin)
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
    Question.new_member_questions.each do |q|
      cards.create!(resource: q)
    end
    true
  end

  def send_welcome_message
    UserMailer.welcome_email(self).deliver
  end

  def max_inbox_content?
    cards.inbox.where(:resource_type => Content).count > Card::MAX_CONTENT_PER_USER
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
                            :first_name => 'Better',
                            :last_name => 'Robot',
                            :avatar_url_override => "http://i.imgur.com/c3vNPCO.jpg")
  end

  def agreement_params=(params)
    self.user_agreements_attributes = params[:ids].map{|id| {:user => self,
                                                             :agreement_id => id,
                                                             :ip_address => params[:ip_address],
                                                             :user_agent => params[:user_agent]}}
  end

  def terms_of_service_and_privacy_policy
    user_agreements.map(&:agreement_id).to_set.superset?(Agreement.active.pluck(:id).to_set)
  end
end
