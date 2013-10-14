class UserReading < ActiveRecord::Base
  belongs_to :user
  belongs_to :content

  attr_accessible :user, :content, :view_count, :save_count, :dismiss_count, :share_count

  validates :user, :content, :view_count, :save_count, :dismiss_count, :share_count, presence: true
  validates :content_id, :uniqueness => {:scope => :user_id}
end
