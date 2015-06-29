class User < ActiveRecord::Base
  serialize :client_data, Hash

  has_many :associations, dependent: :destroy, inverse_of: :user
  has_many :associates, through: :associations
  has_many :inverse_associations, class_name: 'Association',
                                  foreign_key: 'associate_id',
                                  inverse_of: :associate,
                                  dependent: :destroy
  has_many :inverse_associates, through: :inverse_associations, source: :user

  has_many :heights, inverse_of: :user
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
  has_many :addresses, inverse_of: :user
  has_many :phone_numbers, as: :phoneable,
                           inverse_of: :phoneable,
                           dependent: :destroy
  has_many :insurance_policies
  has_one :provider
  has_one :emergency_contact

  belongs_to :default_hcp_association, class_name: 'Association', foreign_key: :default_hcp_association_id
  has_one :default_hcp, through: :default_hcp_association, source: :associate

  belongs_to :owner, class_name: 'User',
                     inverse_of: :owned_users
  has_many :owned_users, class_name: 'User',
                         foreign_key: :owner_id,
                         inverse_of: :owner

  has_many :subject_user_programs, class_name: 'UserProgram',
                                   foreign_key: :subject_id,
                                   dependent: :destroy

  has_many :appointments
  has_many :user_changes
  has_many :user_images, inverse_of: :user,
                         dependent: :destroy

  has_many :provider_searches

  accepts_nested_attributes_for :user_information
  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :provider
  accepts_nested_attributes_for :emergency_contact

  attr_accessor :self_owner
  attr_accessor :actor_id

  attr_accessible :first_name, :last_name, :avatar, :gender, :birth_date, :email,
                  :blood_type, :diet_id, :ethnic_group_id, :npi_number, :deceased,
                  :date_of_death, :expertise, :city, :avatar_url_override, :client_data,
                  :user_information_attributes, :addresses_attributes,
                  :provider_attributes, :nickname, :default_hcp_association_id,
                  :provider_taxonomy_code, :owner, :owner_id, :self_owner, :emergency_contact_attributes,
                  :actor_id, :due_date, :remote_avatar_url,
                  :phone, :work_phone_number, :text_phone_number

  validate :member_flag_is_nil
  validates :deceased, :inclusion => {:in => [true, false]}
  validates :npi_number, :length => {:is => 10}, :uniqueness => true, :if => :npi_number
  validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}, allow_blank: true
  validates :phone, format: PhoneNumber::VALIDATION_REGEX, allow_blank: true
  validates :work_phone_number, format: PhoneNumber::VALIDATION_REGEX, allow_blank: true
  validates :text_phone_number, format: PhoneNumber::VALIDATION_REGEX, allow_blank: true

  mount_uploader :avatar, AvatarUploader

  before_validation :set_owner, on: :create
  before_validation :unset_member_flag
  before_validation :set_defaults
  before_validation :strip_attributes
  before_create :create_google_analytics_uuid
  after_commit :publish
  after_save :track_update, on: :update

  after_create :add_gravatar

  def add_gravatar
    if self.avatar_url_override.nil? || self.avatar_url_override.include?('https://secure.gravatar.com/avatar')
      self.avatar_url_override = GravatarChecker.new(email).check_gravatar
      self.save
    end
  end

  def phone_reader(phone_type)
    return unless [:phone, :work_phone_number, :text_phone_number].include?(phone_type)
    phone_type_name = "#{phone_type}_obj".to_sym
    self.send(phone_type_name).try(:number)
  end

  PREDEFINED_PHONE_NUMBER_ATTRS = {
    phone:             { primary: true, type: "Home" },
    work_phone_number: { primary: false, type: "Work" },
    text_phone_number: { primary: false, type: "Mobile" }
  }

  def phone_setter(new_phone, phone_type)
    new_prepped_phone = PhoneNumber.prep_phone_number_for_db(new_phone)

    return unless [:phone, :work_phone_number, :text_phone_number].include?(phone_type)
    phone_type_name = "#{phone_type}_obj".to_sym
    found_phone_number = self.send(phone_type_name)

    if found_phone_number && new_prepped_phone.nil?
      found_phone_number.destroy
    elsif found_phone_number && found_phone_number.number != new_prepped_phone
      found_phone_number.update_attributes(number: new_prepped_phone)
    elsif found_phone_number.nil? && new_prepped_phone.present?
      new_phone_attrs = PREDEFINED_PHONE_NUMBER_ATTRS[phone_type].merge({number: new_prepped_phone})
      phone_numbers.build(new_phone_attrs)
    end
  end

  def phone
    phone_reader(:phone)
  end

  def phone=(new_phone)
    phone_setter(new_phone, :phone)
  end

  def phone_obj
    phone_numbers.find_by_primary(true)
  end

  def work_phone_number
    phone_reader(:work_phone_number)
  end

  def work_phone_number=(new_work_phone_number)
    phone_setter(new_work_phone_number, :work_phone_number)
  end

  def work_phone_number_obj
    phone_numbers.find_by_type("Work")
  end

  def text_phone_number
    phone_reader(:text_phone_number)
  end

  def text_phone_number=(new_text_phone_number)
    phone_setter(new_text_phone_number, :text_phone_number)
  end

  def text_phone_number_obj
    phone_numbers.find_by_type("Mobile")
  end

  def test?
    /\@(getbetter|example).com$/i =~ email
  end

  def actor_id
    @actor_id || id
  end

  def avatar=(encoded_avatar)
    if avatar_url && encoded_avatar.nil?
      self.remove_avatar = true
    else
      super
    end
  end

  def full_name
    if last_name.present?
      if first_name.present?
        return "#{first_name} #{last_name}"
      end

      if gender == 'M'
        return "Mr. #{last_name}"
      elsif gender == 'F'
        return "Ms. #{last_name}"
      end

      return "Mr./Ms. #{last_name}"
    elsif first_name.present?
      return first_name
    end

    email
  end

  def gender_possessive
    case gender.try(:downcase)
    when 'm', 'male'
      'his'
    when 'f', 'female'
      'her'
    else
      'his/her'
    end
  end

  def gender_pronoun
    case gender.try(:downcase)
    when 'm', 'male'
      'he'
    when 'f', 'female'
      'she'
    else
      'they'
    end
  end

  def salutation
    first_name ? first_name : 'there'
  end

  def age
    if birth_date.nil?
      nil
    else
      now = Time.now.utc.to_date
      now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
    end
  end

  def member
    return nil unless email
    Member.find_by_email(email)
  end

  def member_or_invite!(inviter)
    return member if member
    Member.create_from_user!(self, inviter).tap do |new_member|
      inviter.invitations.create!(invited_member: new_member)
    end
  end

  def blood_pressure
    blood_pressures.most_recent
  end

  def height
    heights.most_recent.try(:amount)
  end

  def weight
    weights.most_recent
  end

  def taxonomy_classification
    provider_taxonomy_code.nil? ? nil : HCPTaxonomy.get_classification_by_hcp_code(provider_taxonomy_code)
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

  def set_default_hcp(association_id)
    self.update_attribute(:default_hcp_association_id, association_id)
  end

  def remove_default_hcp
    self.update_attribute(:default_hcp_association_id, nil)
  end

  #############################################################################
  # Billing
  #############################################################################
  def credit_cards
    return [] if stripe_customer_id.nil?

    customer = Stripe::Customer.retrieve(stripe_customer_id)
    cards = customer.cards.data
    if cards.empty?
      []
    else
      if cards.length == 1
        card = cards.first
      else
        card = customer.cards.retrieve(customer.default_card)
      end

      hash = {
        type:      card.type,
        last4:     card.last4.to_i,
        exp_month: card.exp_month.to_i,
        exp_year:  card.exp_year.to_i
      }

      [hash]
    end
  end

  def subscription
    return [] if stripe_customer_id.nil?

    customer = Stripe::Customer.retrieve(stripe_customer_id)
    array = []
    customer.subscriptions.each do |subscription|
      array << StripeExtension.subscription_serializer(subscription)
    end
    array
  end

  def remove_all_credit_cards
    return if stripe_customer_id.nil?

    customer = Stripe::Customer.retrieve(stripe_customer_id)
    customer.cards.each {|card| card.delete}
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

  def publish
    unless id_changed?
      PubSub.publish "/users/#{id}/update", { id: id }
    end
  end

  private

  def self_owner
    @self_owner || false
  end

  def set_owner
    if self_owner || npi_number.present?
      self.owner ||= self
    end
  end

  def member_flag_is_nil
    if instance_of?(User)
      errors.add(:member_flag, 'Member flag must be unset') unless member_flag.nil?
    else
      true
    end
  end

  def unset_member_flag
    if instance_of?(User)
      self.member_flag = nil
    end
  end

  def set_defaults
    self.deceased = false if deceased.nil?
    true
  end

  def strip_attributes
    self.first_name = first_name.try(:strip)
    self.last_name = last_name.try(:strip)
    self.nickname = nickname.try(:strip)
    self.email = email.try(:strip)
  end

  def create_google_analytics_uuid
    self.google_analytics_uuid = SecureRandom.uuid
  end

  def track_update
    changes = self.changes.except(:created_at, :updated_at, :avatar)
    return if changes.empty?
    @actor_id ||= Member.robot.id
    UserChange.create! user: self, actor_id: actor_id, action: 'update', data: changes
  end
end
