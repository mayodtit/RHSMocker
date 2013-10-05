class UserContentLike < ActiveRecord::Base
  belongs_to :user
  belongs_to :content

  validates_presence_of :user_id, :content_id, :action
  validates_uniqueness_of :user_id, scope: :content_id
  validates_inclusion_of :action, in: [1, -1]
end
