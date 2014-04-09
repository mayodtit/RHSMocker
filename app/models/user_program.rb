class UserProgram < ActiveRecord::Base
  belongs_to :user
  belongs_to :program

  attr_accessible :user, :user_id, :program, :program_id

  validates :user, :program, presence: true
end
