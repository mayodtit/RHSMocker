class UserPromotion < ActiveRecord::Base
  belongs_to :user
  belongs_to :promotion

  attr_accessible :promotion_id, :user, :user_id, :promotion

  validates :user, :promotion, presence: true
  validates :promotion_id, :uniqueness => {:scope => :user_id}
end
