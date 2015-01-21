class UserInformation < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :notes, :highlights, :actor_id
  attr_accessor :actor_id

  validates :user, presence: true
  validates :user_id, uniqueness: true

  after_destroy :track_destroy
  after_create :track_create
  after_update :track_update

  def track_create
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: 'add', data: {informations: [user.first_name, user.last_name]}.to_s
  end

  def track_update
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: 'update', data: {informations: [user.first_name, user.last_name]}.to_s
  end

  def track_destroy
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: 'destroy', data: {informations: [user.first_name, user.last_name]}.to_s
  end
end
