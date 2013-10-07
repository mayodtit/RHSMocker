class Member < User
  authenticates_with_sorcery!

  has_many :user_agreements, :foreign_key => :user_id
  has_many :agreements, :through => :user_agreements
  has_many :cards, :foreign_key => :user_id
  has_many :user_readings, :order => 'read_date DESC', :foreign_key => :user_id
  has_many :contents, :through => :user_readings
  has_many :messages, :foreign_key => :user_id
  has_many :consult_users, :foreign_key => :user_id
  has_many :consults, :through => :consult_users
  has_many :message_statuses, :foreign_key => :user_id
  has_many :locations, :foreign_key => :user_id

  has_many :user_plans, :foreign_key => :user_id
  has_many :plans, :through => :user_plans
  has_many :user_offerings, :foreign_key => :user_id
  has_many :offerings, :through => :user_offerings

  has_many :invitations

  accepts_nested_attributes_for :user_agreements

  attr_accessible :install_id, :generic_call_time, :password, :password_confirmation, :feature_bucket,
                  :holds_phone_in, :invitation_token, :units, :agreement_params

  validates :email, :uniqueness => {:message => 'account already exists', :case_sensitive => false}, :allow_nil => true
  validates :password, :length => {:minimum => 8, :message => "must be 8 or more characters long"}, :confirmation => true, :if => :password
  validates :install_id, :uniqueness => true, :allow_nil => true
  validates :phone, :length => {:in => 7..17, :message => 'must be between 7 and 17 digits'}, :allow_blank => true
  validates :units, :inclusion => {:in => %w(US Metric)}
  validates :terms_of_service_and_privacy_policy, :acceptance => {:accept => true}, :on => :create, :if => lambda{|m| m.email.present?}

  # TODO - KC - remove these validations, I don't think they're used anymore
  validates :generic_call_time, :allow_nil => true, :inclusion => {:in => %w(morning afternoon evening),
                                                    :message => "%{value} is not a call time" }
  validates :feature_bucket, :allow_nil => true, :inclusion => {:in => %w(none message_only call_only message_call),
                                                                :message => "%{value} is not a valid value for feature_bucket"}

  after_create :login # generate inital auth_token
  after_create :add_install_message
  after_create :add_new_member_content
  after_create :send_welcome_message, :if => lambda{|m| m.email.present?}

  searchable do
    text :name do
      "#{first_name} #{last_name}"
    end
    string :role_name, :multiple => true do
      roles.map(&:name)
    end
  end

  BASE_OPTIONS = User::BASE_OPTIONS.merge(:only => [:feature_bucket, :generic_call_time,
                                                    :holds_phone_in, :install_id,
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

  def can_call?
    self.hcp? || self.feature_bucket == 'call_only' || self.feature_bucket == 'message_call'
  end

  def merge user
    user.user_readings.each do |ur|
      logged_in_user_reading = UserReading.find_by_user_id_and_content_id id, ur.content_id
      if logged_in_user_reading
        logged_in_user_reading.merge(ur)
        UserReading.destroy(ur.id)
      else
        ur.update_attribute :user_id, id
      end
    end
    User.destroy(user.id)
  end

  #Keywords (aka search history)
  def keywords
    keywords = {}
    user_readings.map{|ur| ur.read_date ? ur.content.mayo_vocabularies : [] }.each do |mvs|
      mvs.each do |mv|
        if keywords.has_key? mv
          keywords[mv]+=1
        else
          keywords[mv]=1
        end
      end
    end
    keywords.sort_by{|x,y| keywords[x]<=>keywords[y]}
  end

  def add_install_message
    if Content.install_message
      user_readings.create!(content: Content.install_message, # TODO - remove when UserReadings retired
                            read_date: Time.zone.now.iso8601,
                            save_date: Time.zone.now.iso8601,
                            save_count: 1)
      cards.create!(resource: Content.install_message,
                    state: :saved,
                    state_changed_at: Time.zone.now.iso8601)
    end
    true
  end

  def add_new_member_content
    Content.new_member_content.each do |c|
      user_readings.create!(content: c) # TODO - remove when UserReadings retired
      cards.create!(resource: c)
    end
    Question.new_member_questions.each do |q|
      cards.create!(resource: q)
    end
    true
  end

  def send_welcome_message
    UserMailer.welcome_email(self).deliver
  end

  def allowed_to_edit_user? user_id
    user_id == id || admin? || associates.map(&:id).include?(user_id)
  end

  def hasMaxContent
    user_readings.unread.count >= 7 && cards.inbox.count >= 7
  end

  def getContent
      gender_not_array = []
      age_array = []

      #Add Gender MCVIDS - these are usedin a NOT clause, so the logic is flipped

      if !gender.nil?
          gender_not_array = Content.byGender(gender)
      end

      if !age.nil?
          age_array = Content.mcvidsForAge(age)
      end

      contents = Content.joins(:mayo_vocabularies)
                        .where(:mayo_vocabularies => {:mcvid => age_array})
                        .where("contents.id NOT IN (#{user_readings.pluck(:content_id).join(', ')})")
                        .reject{|c| gender_not_array.include?(c.id)}

       # Cannot be in reading list

      #All Else Fails, pick something reasonably random
      if contents.empty?
        Content.getRandomContent()
      else
        contents.first
      end
  end

  def invite!
    return if crypted_password.present?
    update_attributes!(:invitation_token => Base64.urlsafe_encode64(SecureRandom.base64(36)))
    UserMailer.invitation_email(self).deliver
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
                            :last_name => 'Robot')
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
