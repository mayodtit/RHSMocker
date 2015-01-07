class UserInformation < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :notes, :highlights

  validates :user, presence: true
  validates :user_id, uniqueness: true

  after_destroy :track_destroy
  after_create :track_create

  def track_create
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: 'add', data: {infomations: [user.first_name, user.last_name]}.to_s
  end

  def track_destroy
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: 'destroy', data: {informations: [user.first_name, user.last_name]}.to_s
  end
end
