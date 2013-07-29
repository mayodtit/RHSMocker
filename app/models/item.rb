class Item < ActiveRecord::Base
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

  private

  def set_default_priority
    self.priority = 0
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
