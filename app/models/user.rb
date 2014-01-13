require './lib/utils/phone_number_util'

class User < ActiveRecord::Base
  serialize :client_data, Hash

  rolify

  has_many :associations, :dependent => :destroy
  has_many :associates, :through=>:associations
  has_many :inverse_associations, :class_name => 'Association', :foreign_key => 'associate_id'
  has_many :inverse_associates, :through => :inverse_associations, :source => :user

  has_many :weights
  has_many :blood_pressures
  has_many :user_allergies
  has_many :allergies, :through=>:user_allergies
  has_many :user_conditions
  has_many :conditions, :through=> :user_conditions
  has_many :user_treatments
  has_many :treatments, :through=> :user_treatments
  belongs_to :ethnic_group
  belongs_to :diet
  has_one :user_information
  has_one :address
  has_one :insurance_policy
  has_one :provider

  accepts_nested_attributes_for :user_information
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :insurance_policy
  accepts_nested_attributes_for :provider

  attr_accessible :first_name, :last_name, :avatar, :gender, :height, :birth_date, :email,
                  :phone, :blood_type, :diet_id, :ethnic_group_id, :npi_number, :deceased,
                  :date_of_death, :expertise, :city, :state, :avatar_url_override, :client_data,
                  :user_information_attributes, :address_attributes, :insurance_policy_attributes,
                  :provider_attributes, :work_phone_number

  validates :deceased, :inclusion => {:in => [true, false]}
  validates :npi_number, :length => {:is => 10}, :uniqueness => true, :if => :npi_number
  validates :phone, format: PhoneNumberUtil::VALIDATION_REGEX, allow_nil: true
  validates :work_phone_number, format: PhoneNumberUtil::VALIDATION_REGEX, allow_nil: true

  mount_uploader :avatar, AvatarUploader

  before_validation :prep_phone_numbers
  before_validation :set_defaults
  before_create :create_google_analytics_uuid

  # TODO - I think this should be moved to Member, needs investigation
  def full_name
    return email if first_name.blank? || last_name.blank?
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

  BASE_OPTIONS = {:only => [:id, :first_name, :last_name, :birth_date, :blood_type,
                            :diet_id, :email, :ethnic_group_id, :gender, :height,
                            :deceased, :date_of_death, :npi_number, :expertise],
                  :methods => [:blood_pressure, :avatar_url, :weight, :admin?, :nurse?, :pha?, :care_provider?, :ethnic_group, :diet]}

  def serializable_hash(options = nil)
    options = BASE_OPTIONS if options.blank?
    super(options)
  end

  def member
    return nil unless email
    Member.find_by_email(email)
  end

  def blood_pressure
    blood_pressures.most_recent
  end

  def weight
    weights.most_recent
  end

  def avatar_url
    avatar_url_override || avatar.url
  end

  def gender_url
    case gender
    when 'M'
      'profilepic_M_L@2x.png'
    when 'F'
      'profilepic_F_L@2x.png'
    else
      'profilepic_U_L@2x.png'
    end
  end

  def avatar_or_gender_url
    avatar_url || gender_url
  end

  def self.members
    where(type: 'Member')
  end

  #############################################################################
  # Rather than using ActiveRecord associations, these like/dislike actions
  # and fetchers are broken out into their own methods in case we decide to
  # move to a different relationship store (such as a graph DB)
  #############################################################################
  def like_content(content_id)
    like_dislike_content_common(content_id, 'like')
  end

  def dislike_content(content_id)
    like_dislike_content_common(content_id, 'dislike')
  end

  def remove_content_like(content_id)
    ucl = UserContentLike.find_by_user_id_and_content_id(id, content_id)
    ucl.destroy if ucl
  end

  def content_likes
    content_likes_dislikes_common('like')
  end

  def content_dislikes
    content_likes_dislikes_common('dislike')
  end

  def like_dislike_content_common(content_id, action)
    ucl = UserContentLike.find_by_user_id_and_content_id(id, content_id)
    if ucl
      ucl.update_attributes(action: action) unless ucl.action == action
      ucl
    else
      UserContentLike.create!(user_id: id, content_id: content_id, action: action)
    end
  end

  def content_likes_dislikes_common(action)
    ucl = UserContentLike.where(user_id: id, action: action).pluck(:content_id)
    Content.where(id: ucl)
  end
  #############################################################################

  private

  def prep_phone_numbers
    self.phone = PhoneNumberUtil::prep_phone_number_for_db self.phone
    self.work_phone_number = PhoneNumberUtil::prep_phone_number_for_db self.work_phone_number
  end

  def set_defaults
    self.deceased = false if deceased.nil?
    true
  end

  def create_google_analytics_uuid
    self.google_analytics_uuid = SecureRandom.uuid
  end
end
