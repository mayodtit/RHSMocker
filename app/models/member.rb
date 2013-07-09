class Member < User
  authenticates_with_sorcery!

  has_many :user_readings, :order => 'read_date DESC'
  has_many :contents, :through => :user_readings
  has_many :content_authors
  has_many :messages
  has_many :feedbacks
  has_many :encounters_users
  has_many :encounters, :through => :encounters_users
  has_many :message_statuses
  has_many :user_locations

  has_many :agreements
  has_many :agreement_pages, :through => :agreements
  has_many :user_plans
  has_many :plans, :through => :user_plans
  has_many :user_offerings
  has_many :offerings, :through => :user_offerings

  attr_accessible :install_id, :generic_call_time, :password, :password_confirmation, :feature_bucket,
                  :holds_phone_in

  validates :install_id, :uniqueness => true, :allow_nil => true
  validates :email, :allow_nil => true, :uniqueness => {:message => 'account already exists'}
  validates :phone, :allow_blank => true, :length => {:in => 7..17}
  validates :password, :length => {:minimum => 8, :message => "must be at least 8 characters long"}, :confirmation => true, :if => :password
  validates :generic_call_time, :allow_nil => true, :inclusion => {:in => %w(morning afternoon evening),
                                                    :message => "%{value} is not a call time" }
  validates :feature_bucket, :allow_nil => true, :inclusion => {:in => %w(none message_only call_only message_call),
                                                                :message => "%{value} is not a valid value for feature_bucket"}

  after_create :add_install_message
  after_create :add_new_member_content

  searchable do
    text :name do
      "#{first_name} #{last_name}"
    end
    string :role_name, :multiple => true do
      roles.map(&:name)
    end
  end

  def as_json options=nil
    super.merge!({
      feature_bucket:feature_bucket,
      generic_call_time:generic_call_time,
      holds_phone_in:holds_phone_in,
      install_id:install_id,
      phone:phone,
    })
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
      user_readings.create!(content: Content.install_message,
                            read_date: Time.zone.now.iso8601,
                            save_date: Time.zone.now.iso8601,
                            save_count: 1)
    end
    true
  end

  def add_new_member_content
    Content.new_member_content.each do |c|
      user_readings.create!(content: c)
    end
    true
  end

  def allowed_to_edit_user? user_id
    user_id == id || admin? || associates.map(&:id).include?(user_id)
  end

  def hasMaxContent
    self.user_readings.where(:read_date => nil, :dismiss_date => nil, :read_later_count => 0).count >= 7
  end
end
