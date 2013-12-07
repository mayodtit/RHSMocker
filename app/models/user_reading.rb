class UserReading < ActiveRecord::Base
  belongs_to :user
  belongs_to :content

  attr_accessible :user, :content, :viewed_count, :saved_count, :dismissed_count, :shared_count

  validates :user, :content, :viewed_count, :saved_count, :dismissed_count, :shared_count, presence: true
  validates :content_id, :uniqueness => {:scope => :user_id}

  def self.increment_event!(user, content, event)
    send("increment_#{event}!", user, content)
  end

  def self.increment_viewed!(user, content)
    increment_attribute!(user, content, :viewed_count)
  end

  def self.increment_saved!(user, content)
    increment_attribute!(user, content, :saved_count)
  end

  def self.increment_dismissed!(user, content)
    increment_attribute!(user, content, :dismissed_count)
  end

  def self.increment_shared!(user, content)
    increment_attribute!(user, content, :shared_count)
  end

  private

  def self.increment_attribute!(user, content, type)
    ur = where(:user_id => user.id, :content_id => content.id).first_or_initialize
    ur.instance_eval{ increment_attribute!(type) }
  end

  def increment_attribute!(type)
    increment(type).update_attributes!(type => self[type])
    self
  end
end
