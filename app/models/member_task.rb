class MemberTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  PRIORITY = 3

  belongs_to :subject, class_name: 'User'

  attr_accessible :subject_id, :subject

  validates :member, presence: true
  validates :subject, presence: true
  validates :service_type, presence: true

  def set_priority
    self.priority = PRIORITY
  end
  
  def publish
    super

    if id_changed?
      PubSub.publish "/members/#{member_id}/subjects/#{subject_id}/tasks/new", {id: id}, pubsub_client_id
    else
      PubSub.publish "/members/#{member_id}/subjects/#{subject_id}/tasks/update", {id: id}, pubsub_client_id
    end
  end
end
