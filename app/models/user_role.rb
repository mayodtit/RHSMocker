class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  attr_accessible :user, :user_id, :role, :role_id

  validates :user, :role, presence: true
  validates :role_id, uniqueness: {scope: :user_id}
end
