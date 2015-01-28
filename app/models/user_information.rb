class UserInformation < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :notes, :highlights, :actor_id
  attr_accessor :actor_id

  validates :user, presence: true
  validates :user_id, uniqueness: true

  after_destroy {|c| c.track_changes 'destroy'}
  after_create {|c| c.track_changes 'add'}
  after_update {|c| c.track_changes 'update'}

  def track_changes(action)
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: action, data: {changed_attributes: [ UserInformation.changed ]}
  end
end
