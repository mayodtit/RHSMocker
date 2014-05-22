class UserRequest < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :subject, class_name: 'User'

  attr_accessible :user, :user_id, :subject, :subject_id, :name

  validates :user, :subject, :name, presence: true
end
