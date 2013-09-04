class Message < ActiveRecord::Base
  belongs_to :user # that sent this message
  belongs_to :consult
  has_many :message_statuses

  belongs_to :content
  belongs_to :location
  has_many :message_mayo_vocabularies
  has_many :mayo_vocabularies, :through => :message_mayo_vocabularies
  has_many :attachments
  belongs_to :scheduled_phone_call, :inverse_of => :message
  belongs_to :phone_call, :inverse_of => :message

  attr_accessible :user, :user_id, :consult, :consult_id, :content, :content_id, :text,
                  :new_location, :new_keyword_ids, :new_attachments, :scheduled_phone_call,
                  :scheduled_phone_call_id, :phone_call, :phone_call_id,
                  :scheduled_phone_call_attributes, :phone_call_attributes

  validates :user, :consult, :text, presence: true
  validates :content, presence: true, if: lambda{|m| m.content_id.present?}

  before_create :add_user_to_consult
  after_create :create_message_statuses_for_users
  after_create :notify_members

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :message_mayo_vocabularies
  accepts_nested_attributes_for :attachments
  accepts_nested_attributes_for :scheduled_phone_call
  accepts_nested_attributes_for :phone_call

  def new_location=(attributes)
    self.location_attributes = attributes.merge!(:user => user)
  end

  def new_keyword_ids=(ids)
    self.message_mayo_vocabularies_attributes = ids.inject([]){|a, id| a << {:mayo_vocabulary_id => id, :message => self}; a}
  end

  def new_attachments=(attributes)
    self.attachments_attributes = attributes
  end

  def title
    "Conversation with a Health Advocate"
  end

  def content_type
    'Message'
  end

  def previewText
    text.split(' ').slice(0, 21).join(' ')+"&hellip;" if text.present?
  end
  alias_method :preview, :previewText

  BASE_OPTIONS = {:only => [:id, :text, :created_at],
                  :methods => :title,
                  :include => {:location => {},
                               :attachments => {},
                               :mayo_vocabularies => {},
                               :content => {},
                               :user => {:only => :id, :methods => :full_name}}}

  def serializable_hash(options=nil)
    super(options || BASE_OPTIONS)
  end

  def self.phone_params(type, user, consult, nested_params=nil)
    params = {user: user, consult: consult, text: phone_text(type)}
    params.merge!((type.to_s + "_attributes").to_sym => nested_params.merge!(:user => user)) if nested_params
    params
  end

  def self.unread_user_ids
    joins(:message_statuses)
    .where(:message_statuses => {:status => :unread})
    .pluck('distinct message_statuses.user_id')
  end

  def self.with_message_statuses_for(user)
    joins("LEFT OUTER JOIN message_statuses
           ON message_statuses.message_id = messages.id
           AND message_statuses.user_id = #{user.id}")
    .select('messages.*, message_statuses.status')
  end

  private

  def add_user_to_consult
    consult.add_user = user
  end

  def create_message_statuses_for_users
    consult.members.each do |user|
      user.message_statuses.create!(message: self, status: :unread)
    end
  end

  def self.phone_text(type)
    case type
    when :phone_call
      'Phone call!'
    when :scheduled_phone_call
      'Scheduled phone call!'
    end
  end

  def notify_members
    consult.notify_members
  end
end
