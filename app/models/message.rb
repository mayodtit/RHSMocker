class Message < ActiveRecord::Base
  belongs_to :user # that sent this message
  belongs_to :encounter

  belongs_to :content
  has_many :message_mayo_vocabularies
  has_many :mayo_vocabularies, :through => :message_mayo_vocabularies

  belongs_to :user_location
  has_many :attachments
  has_many :message_statuses
  has_one :phone_call

  attr_accessible :user, :user_id, :encounter, :encounter_id, :content, :content_id, :text

  validates :user, :encounter, :text, presence: true
  validates :content, presence: true, if: lambda{|m| m.content_id.present?}

  before_create :add_user_to_encounter

  def mayo_vocabulary_ids=(ids)
    ids.each do |id|
      message_mayo_vocabularies.build(:mayo_vocabulary_id => id)
    end
  end

  def attachment_urls=(urls)
    urls.each do |url|
      attachments.build(:url => url)
    end
  end

  def location=(params)
    user_location.build(params)
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
                           :include => [:user_location, :attachments, :mayo_vocabularies, :content])
    super(options)
  end

  private

  def add_user_to_encounter
    encounter.add_user = user
  end
end
