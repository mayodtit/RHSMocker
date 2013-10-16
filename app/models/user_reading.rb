class UserReading < ActiveRecord::Base
  belongs_to :user
  belongs_to :content

  attr_accessible :user, :content, :view_count, :save_count, :dismiss_count, :share_count

  validates :user, :content, :view_count, :save_count, :dismiss_count, :share_count, presence: true
  validates :content_id, :uniqueness => {:scope => :user_id}

  def self.increment_view!(user, content)
    increment_attribute!(user, content, :view_count)
  end

  def self.increment_save!(user, content)
    increment_attribute!(user, content, :save_count)
  end

  def self.increment_dismiss!(user, content)
    increment_attribute!(user, content, :dismiss_count)
  end

  def self.increment_share!(user, content)
    increment_attribute!(user, content, :share_count)
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
