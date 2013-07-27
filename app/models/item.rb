class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, polymorphic: true

  attr_accessible :user, :resource
  attr_accessible :user_id, :resource_id, :resource_type, :state, :state_changed_at, :state_event

  validates :user, :resource, presence: true
  validates :resource_id, :uniqueness => {:scope => [:user_id, :resource_type]}

  def self.inbox_or_timeline
    where(:state => [:unread, :read, :saved])
  end

  def self.inbox
    where(:state => [:unread, :read])
  end

  def self.timeline
    where(:state => :saved)
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
