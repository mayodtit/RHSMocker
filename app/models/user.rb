class User < ActiveRecord::Base

  rolify
  authenticates_with_sorcery!

  has_many :associations, :dependent => :destroy
  has_many :associates, :through=>:associations
  has_many :inverse_associations, :class_name => 'Association', :foreign_key => 'associate_id'
  has_many :inverse_associates, :through => :inverse_associations, :source => :user

  has_many :user_readings, :order => 'read_date DESC'
  has_many :contents, :through => :user_readings
  has_many :content_authors
  has_many :messages
  has_many :feedbacks
  has_many :encounters_users
  has_many :encounters, :through => :encounters_users
  has_many :message_statuses
  has_many :user_locations

  has_many :user_weights
  has_many :blood_pressures
  has_many :user_allergies
  has_many :allergies, :through=>:user_allergies
  has_many :user_diseases
  has_many :diseases, :through=> :user_diseases
  has_many :user_disease_treatments
  has_many :treatments, :through=> :user_disease_treatments
  belongs_to :ethnic_group
  belongs_to :diet

  has_many :agreements
  has_many :agreement_pages, :through => :agreements
  has_many :user_plans
  has_many :plans, :through => :user_plans
  has_many :user_offerings
  has_many :offerings, :through => :user_offerings

  attr_accessible :first_name, :last_name, :image_url, :gender, :height, :birth_date, :install_id, :email, :phone,
                  :generic_call_time, :password, :password_confirmation, :feature_bucket, :blood_type, :holds_phone_in,
                  :diet_id, :ethnic_group_id, :npi_number, :deceased, :date_of_death, :expertise, :city, :state

  validates :install_id, :presence => true, :uniqueness => true
  validates :email, :allow_nil => true, :uniqueness => {:message => 'account already exists'}
  validates :phone, :allow_blank => true, :length => {:in => 7..17}
  validates :password, :length => {:minimum => 8, :message => "must be at least 8 characters long"}, :confirmation => true, :if => :password
  validates :generic_call_time, :allow_nil => true, :inclusion => {:in => %w(morning afternoon evening),
                                                    :message => "%{value} is not a call time" }
  validates :feature_bucket, :allow_nil => true, :inclusion => {:in => %w(none message_only call_only message_call),
                                                                :message => "%{value} is not a valid value for feature_bucket"}
  validates :npi_number, :length => {:is => 10}, :uniqueness => true, :if => :npi_number
  validates :deceased, :inclusion => {:in => [true, false]}

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

  def self.by_role(role)
    return [] unless role
    role_id = role.try_method(:id) || role
    joins(:roles).where(:roles => {:id => role_id})
  end

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
