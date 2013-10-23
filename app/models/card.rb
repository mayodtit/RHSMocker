class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, polymorphic: true

  attr_accessible :user, :user_id, :resource, :resource_id, :resource_type,
                  :state, :state_event, :state_changed_at, :priority

  validates :user, :resource, presence: true
  validates :resource_id, :uniqueness => {:scope => [:user_id, :resource_type]}
  validates :state_changed_at, presence: true, unless: :unread?

  before_validation :set_default_priority
  after_create :create_user_reading, :if => lambda{|c| c.content_card? }

  delegate :title, :content_type, :content_type_display, :preview, :abstract, :body, :formatted_body, to: :resource

  def self.inbox
    where(:state => [:unread, :read]).by_priority.reject {|c| c.resource.content_type.downcase == 'disease' if c.content_card? }
  end

  def self.timeline
    where(:state => :saved).by_priority
  end

  def self.not_dismissed
    where(:state => [:unread, :read, :saved]).by_priority
  end

  def self.by_priority
    order('priority DESC')
  end

  def self.for_resource(resource)
    where(:resource_id => resource.id, :resource_type => resource.class.name).first
  end

  def serializable_hash options=nil
    options ||=  {:methods => [:title, :content_type, :content_type_display, :share_url]}
    super(options).merge!(state_specific_date)
  end

  def share_url
    resource.try_method(:root_share_url).try(:+, "/#{id}")
  end

  def content_card?
    resource_type.constantize == Content
  end

  private

  def set_default_priority
    if resource_type == 'Consult'
      self.priority ||= 10
    else
      self.priority ||= 0
    end
  end

  def create_user_reading
    UserReading.where(:user_id => user.id, :content_id => resource.id).first_or_create!
  end

  # TODO - hack this in so the client doesn't have to change field names yet
  def state_specific_date
    if read?
      {:read_date => state_changed_at}
    elsif saved?
      {
        :read_date => state_changed_at,
        :save_date => state_changed_at,
        :dismiss_date => ''
      }
    else
      {}
    end
  end

  state_machine :initial => :unread do
    event :read do
      transition :unread => :read
      transition [:read, :saved, :dismissed] => same
    end

    event :saved do
      transition all => :saved
    end

    event :dismissed do
      transition all => :dismissed
    end

    event :reset do
      transition all => :unread
    end

    before_transition any => [:read, :saved, :dismissed] do |card, transition|
      card.state_changed_at ||= Time.now
    end

    before_transition any => :unread do |card, transition|
      card.state_changed_at = nil
    end

    after_transition any => :saved do |card, transition|
      UserReading.increment_save!(card.user, card.resource) if card.content_card?
    end

    after_transition any => :dismissed do |card, transition|
      UserReading.increment_dismiss!(card.user, card.resource) if card.content_card?
    end

    after_transition any => [:saved, :dismissed] do |card, transition|
      PusherJob.new.push_content(card.user_id)
    end
  end
end
