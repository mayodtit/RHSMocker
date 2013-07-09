class User < ActiveRecord::Base

  rolify
  authenticates_with_sorcery!

  attr_accessible :first_name, :last_name, :image_url, :gender, :height, :birth_date, :install_id, :email, :phone,
                  :generic_call_time, :password, :password_confirmation, :feature_bucket, :blood_type, :holds_phone_in,
                  :diet_id, :ethnic_group_id, :npi_number, :deceased, :date_of_death, :expertise, :city, :state

  after_create :default_content

  #Things the user has read
  has_many :user_readings, :order => 'read_date DESC'
  has_many :contents, :through=>:user_readings

  has_many :messages

  has_many :user_diseases
  has_many :diseases, :through=> :user_diseases

  has_many :weights

  has_many :blood_pressures

  has_many :user_locations

  #All of the content assigned to this user
  has_many :contents, :through => :user_readings

  has_many :content_authors

  has_many :associations, :dependent => :destroy
  has_many :associates, :through=>:associations

  has_many :inverse_associations, :class_name => 'Association', :foreign_key => 'associate_id'
  has_many :inverse_associates, :through => :inverse_associations, :source => :user

  has_and_belongs_to_many :institutions

  has_many :feedbacks

  has_many :encounters_users

  has_many :message_statuses

  has_many :encounters, :through => :encounters_users

  has_many :user_disease_treatments
  has_many :treatments, :through=> :user_disease_treatments

  has_many :user_allergies
  has_many :allergies, :through=>:user_allergies

  belongs_to :ethnic_group
  belongs_to :diet

  has_many :agreements
  has_many :agreement_pages, :through => :agreements

  has_many :user_plans
  has_many :plans, :through => :user_plans

  has_many :user_offerings
  has_many :offerings, :through => :user_offerings

  searchable do
    text :name do
      "#{first_name} #{last_name}"
    end
    string :role_name, :multiple => true do
      roles.map(&:name)
    end
  end

  #Validations
  #++++++++++++++
  validates :install_id, :uniqueness => true, :allow_nil => true
  validates :email, :allow_nil => true, :uniqueness => {:message => 'account already exists'}

  validates :generic_call_time, :inclusion => { :in => %w(morning afternoon evening),
    :message => "%{value} is not a call time" }, :allow_nil => true

  validates :feature_bucket, :inclusion => { :in => %w(none message_only call_only message_call),
    :message => "%{value} is not a valid value for feature_bucket" }, :allow_nil => true

  validates_length_of :phone, :in => 7..17, :allow_blank => true

  validates_length_of :password, :minimum => 8, :message => "must be at least 8 characters long", :if => :password
  validates_confirmation_of :password, :message => "should match confirmation", :if => :password

  validates :npi_number, :length => {:is => 10}, :uniqueness => true, :if => :npi_number
  validates :deceased, :inclusion => {:in => [true, false]}

  def admin?
    has_role? :admin
  end

  def hcp?
    has_role?(:hcp) || has_role?(:admin)
  end

  def full_name
    return "Not Set" if first_name.blank? || last_name.blank?
    "#{first_name} #{last_name}".strip
  end

  def age
    if birth_date.nil?
      birth_date
    else
      now = Time.now.utc.to_date
      now.year - self.birth_date.year - ((now.month > self.birth_date.month || (now.month == self.birth_date.month && now.day >= self.birth_date.day)) ? 0 : 1)
    end
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

  def most_recent_blood_pressure
    BloodPressure.most_recent_for_user(self)
  end

  def most_recent_weight
    Weight.most_recent_for(self)
  end

  def as_json options=nil
    {
      id:id,
      first_name:first_name,
      last_name:last_name,
      birth_date:birth_date,
      blood_type:blood_type,
      diet_id:diet_id,
      email:email,
      ethnic_group_id:ethnic_group_id,
      feature_bucket:feature_bucket,
      gender:gender,
      generic_call_time:generic_call_time,
      height:height,
      holds_phone_in:holds_phone_in,
      image_url:image_url,
      install_id:install_id,
      phone:phone,
      deceased:deceased,
      date_of_death:date_of_death,
      npi_number:npi_number,
      expertise:expertise,
      blood_pressure: most_recent_blood_pressure,
      weight: most_recent_weight
    }
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


  #CONTENT Related methods
  #+++++++++++++++++++++++++++++++++++

  #called to create the install message and the welcome message
  #nasty hack based on known ID's that makes me want to puke
  def default_content
    #if for some reason, the content was not created yet, then there is no default content
    if !Content.where("title = 'Installed Better'").empty?
      UserReading.create(user:self, content:Content.where("title = 'Installed Better'").first, read_date: Time.zone.now.iso8601, save_date: Time.zone.now.iso8601, save_count: 1)
    end
    if !Content.where("title = 'Do you have allergies?'").empty?
      UserReading.create(user:self, content:Content.where("title = 'Do you have allergies?'").first)
    end
    if !Content.where("title = 'What is your gender?'").empty?
      UserReading.create(user:self, content:Content.where("title = 'What is your gender?'").first)
    end
    if !Content.where("title = 'Which hand do you hold your phone in?'").empty?
      UserReading.create(user:self, content:Content.where("title = 'Which hand do you hold your phone in?'").first)
    end
  end

  def allowed_to_edit_user? user_id
    user_id == id || admin? || associates.map(&:id).include?(user_id)
  end

  def readContent
    readingList = Array.new

    if !self.user_readings.empty?
      self.user_readings.order('read_date DESC').includes(:content).each do |reading|
         readingList << reading
      end
    end
  end

  def markRead(content)
    userReadings = UserReading.where("user_id = ? AND content_id = ?", self.id, content.id)
    if userReadings.size == 1 and userReadings.first.read_date.nil?
      userReading = userReadings.first
      userReading.read_date = Time.now
      userReading.save!
      notifyContentChange('read', content.id, content.contentsType)
    else
      userReadings = nil #throw an error on the size or skip on the already dismissed
    end
    #TESTCODE
    self.checkForNewContent
    userReadings
  end

  def markDismissed(content)
    userReadings = UserReading.where("user_id = ? AND content_id = ?", self.id, content.id)
    if userReadings.size == 1 and userReadings.first.dismiss_date.nil? and userReadings.first.read_date.nil?
      userReading = userReadings.first
      userReading.dismiss_date = Time.now
      userReading.save!
      notifyContentChange('dismissed', content.id, content.contentsType)
    else
      userReadings = nil #throw an error on the size or skip on the already dismissed
    end
    #TESTCODE
    self.checkForNewContent
    userReadings
  end

  def markReadLater(content)
    userReadings = UserReading.where("user_id = ? AND content_id = ?", self.id, content.id)
    if userReadings.size == 1 and userReadings.first.read_date.nil?
      userReading = userReadings.first
      userReading.read_later_date, = Time.now
      userReading.read_later_count = userReading.read_later_count + 1 #no ++ incrementor sucks
      userReading.save!
      notifyContentChange('readLater', content.id, content.contentsType)
    else
      userReadings = nil #throw an error on the size or skip on the already dismissed
    end
  end

  def resetReadingList
    self.user_readings.each do |reading|

      if reading.content_id != 1 #nasty hack to not reset installed message
        reading.read_date     = nil
        reading.dismiss_date  = nil
        reading.read_later_count = 0
        reading.read_later_date = nil
        reading.save!
      end
    end
  end

  def notifyContentChange(type, contentID, contentType)
    Pusher['RHS_'+self.id.to_s].trigger(type, {:content_id => contentID, :content_type => contentType})
  end

  def checkForNewContent
    #create something, add to user_Reading, push it out
    if !hasMaxContent
      randomContentID = Content.getRandomContent()
      randomContent = Content.find(randomContentID)
      UserReading.create(user:self, content:randomContent)
      Pusher['RHS_'+self.id.to_s].trigger('newcontent', {:content_id => randomContent.id, :content_type => randomContent.contentsType})
    end
  end

  def hasMaxContent
    self.user_readings.where(:read_date => nil, :dismiss_date => nil, :read_later_count => 0).count >= 7
  end

  def self.by_role(role)
    return [] unless role
    role_id = role.try_method(:id) || role
    joins(:roles).where(:roles => {:id => role_id})
  end
end
