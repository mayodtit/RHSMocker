class UserProgram < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :program
  belongs_to :subject, class_name: 'User'

  attr_accessible :user, :user_id, :program, :program_id, :subject, :subject_id

  validates :user, :program, :subject, presence: true
end
