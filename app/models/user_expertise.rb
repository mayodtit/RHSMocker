class UserExpertise < ActiveRecord::Base
  belongs_to :user
  belongs_to :expertise

  attr_accessible :user, :user_id, :expertise, :expertise_id

  validates :user, :expertise, presence: true
  validates :expertise_id, uniqueness: {scope: :user_id}
end
