class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, polymorphic: true

  attr_accessible :user, :user_id, :resource, :resource_id, :resource_type,
                  :state, :state_event, :state_changed_at

  validates :user, :resource, presence: true
  validates :resource_id, :uniqueness => {:scope => [:user_id, :resource_type]}
  validates :state_changed_at, presence: true, unless: :unread?

  before_validation :set_default_priority

  delegate :title, :content_type, to: :resource

  def share_url
    resource.try_method(:root_share_url).try(:+, "/#{id}")
  end

  def self.inbox_or_timeline
    {
      inbox: inbox.limit(10),
      timeline: timeline.limit(10)
    }
  end

  def self.inbox
    where(:state => [:unread, :read]).order('priority DESC')
  end

  def self.timeline
    where(:state => :saved).order('priority DESC')
  end

  def serializable_hash options=nil
    options ||=  {:methods => [:title, :content_type, :share_url]}
    super(options)
  end

  private

  def set_default_priority
    if resource_type == 'Message'
      self.priority = 10
    else
      self.priority = 0
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
  end
end
