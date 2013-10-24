class Consult < ActiveRecord::Base
  belongs_to :initiator, :class_name => 'Member'
  belongs_to :subject, :class_name => 'User'
  has_many :consult_users
  has_many :users, :through => :consult_users
  has_many :messages
  has_many :scheduled_phone_calls, :through => :messages
  has_many :phone_calls, :through => :messages
  has_many :cards, :as => :resource, :dependent => :destroy

  attr_accessible :initiator, :initiator_id, :subject, :subject_id, :checked,
                  :priority, :status, :add_user, :messages, :message, :image,
                  :scheduled_phone_call, :phone_call, :title, :description

  validates :title, :initiator, :subject, :status, :priority, presence: true
  validates :checked, :inclusion => {:in => [true, false]}
  validates :users, :length => {:minimum => 1}

  before_validation :set_defaults

  symbolize :status, :in => [:open, :closed]

  mount_uploader :image, ConsultImageUploader

  def self.open
    where(:status => :open)
  end

  def message=(params)
    self.messages.build(params.merge!(:consult => self))
  end

  def scheduled_phone_call=(params)
    self.messages.build(Message.phone_params(:scheduled_phone_call, initiator, self, params))
  end

  def phone_call=(params)
    self.messages.build(Message.phone_params(:phone_call, initiator, self, params))
  end

  def add_user=(user)
    self.users << user unless self.users.include?(user)
  end

  BASE_OPTIONS = {:methods => :last_message_at}

  def serializable_hash(options=nil)
    hash = super(options || BASE_OPTIONS)

    # HACK - turning the value of :methods into an array results in test errors,
    # even though the symbol is cast to an array by ActiveModel
    # Adding :image_url and removing :image manually
    hash.merge!({image_url: image_url}).delete(:image)
    hash
  end

  def image_url
    image.url
  end

  def members
    users.where(:type => 'Member')
  end

  def content_type
    'Consult'
  end
  alias_method :content_type_display, :content_type

  def preview
    messages.last.try(:preview) || ''
  end

  def notify_members
    messages.unread_user_ids.each do |id|
      cards.upsert_attributes({:user_id => id},
                              {:state_event => :reset})
    end
  end

  def last_message_at
    messages.order('created_at DESC').select('created_at').first.try(:created_at)
  end

  def self.with_unread_messages_count_for(user)
    joins('LEFT OUTER JOIN messages ON messages.consult_id = consults.id')
    .joins("LEFT OUTER JOIN message_statuses
            ON message_statuses.message_id = messages.id
            AND message_statuses.user_id = #{user.id}
            AND message_statuses.status = 'unread'")
    .select('consults.*, count(message_statuses.id) as unread_messages_count_string')
    .group('consults.id')
  end

  def unread_messages_count
    unread_messages_count_string.to_i
  end

  def most_recent_message
    messages.order('created_at DESC').first
  end

  private

  def set_defaults
    self.status ||= :open
    self.priority ||= 'medium'
    self.checked = false if checked.nil?
    self.title = "Consult for #{subject.first_name}" unless self.title.present?
    true
  end
end
