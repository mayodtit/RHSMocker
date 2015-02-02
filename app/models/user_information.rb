class UserInformation < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :notes, :highlights, :actor_id
  attr_accessor :actor_id

  validates :user, presence: true
  validates :user_id, uniqueness: true

  after_destroy :track_destroy
  after_create {|c| c.track_changes 'add'}
  after_update {|c| c.track_changes 'update'}

  def track_changes(action)
    self.actor_id ||= Member.robot.id
    changes = self.changes
    unless changes.empty?
      UserChange.create! user: user, actor_id: actor_id, action: action, data: changes
    end
  end

  def track_destroy
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: 'destroy', data: {user_information: self.as_json}
  end
end
