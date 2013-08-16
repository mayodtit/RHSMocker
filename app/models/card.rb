class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, polymorphic: true

  attr_accessible :user, :resource
  attr_accessible :user_id, :resource_id, :resource_type, :state, :state_event,
                  :read_at, :saved_at, :dismissed_at

  validates :user, :resource, presence: true
  validates :resource_id, :uniqueness => {:scope => [:user_id, :resource_type]}
  validates :read_at, presence: true, if: :read?
  validates :saved_at, presence: true, if: :saved?
  validates :dismissed_at, presence: true, if: :dismissed?

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

  def as_json options={}
    options.merge!(:only => [:id, :state, :read_at, :dismissed_at, :saved_at],
                   :methods => [:title, :content_type, :share_url]) do |k, v1, v2|
      v1.is_a?(Array) ? v1 + v2 : [v1] + v2
    end
    super(options).keep_if{|k, v| v.present?}
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
