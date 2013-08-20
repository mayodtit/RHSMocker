class Message < ActiveRecord::Base
  belongs_to :user # that sent this message
  belongs_to :consult
  has_many :message_statuses

  belongs_to :content
  belongs_to :location
  has_many :message_mayo_vocabularies
  has_many :mayo_vocabularies, :through => :message_mayo_vocabularies
  has_many :attachments
  belongs_to :scheduled_phone_call
  belongs_to :phone_call

  attr_accessible :user, :user_id, :consult, :consult_id, :content, :content_id, :text,
                  :new_location, :new_keyword_ids, :new_attachments, :scheduled_phone_call_id,
                  :phone_call, :phone_call_id

  validates :user, :consult, :text, presence: true
  validates :content, presence: true, if: lambda{|m| m.content_id.present?}

  before_create :add_user_to_consult
  after_create :create_message_statuses_for_users

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :message_mayo_vocabularies
  accepts_nested_attributes_for :attachments

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

  def serializable_hash(options=nil)
    options ||= {}
    options.reverse_merge!(:only => [:id, :text],
                           :methods => :title,
                           :include => {:location => {},
                                        :attachments => {},
                                        :mayo_vocabularies => {},
                                        :content => {},
                                        :user => {:only => :id, :methods => :full_name}})
    super(options)
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
end
