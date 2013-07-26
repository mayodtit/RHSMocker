class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, polymorphic: true

  attr_accessible :user, :resource

  validates :user, :resource, presence: true
  validates :resource_id, :uniqueness => {:scope => [:user_id, :resource_type]}

  def self.inbox
    where(:state => [:unread, :read])
  end

  def self.timeline
    where(:state => :saved)
  end

  state_machine :initial => :unread do
    event :read do
      transition :unread => :read
    end

    event :saved do
      transition all => :saved
    end

    event :dismissed do
      transition all => :dismissed
    end
  end
end
