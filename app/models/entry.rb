class Entry < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  belongs_to :member
  belongs_to :actor, class_name: "Member"

  validates :member, :resource, presence: true

  attr_accessible :resource, :resource_id, :member, :member_id, :resource_type, :actor, :actor_id

  after_commit :publish, on: :create

  def publish
    PubSub.publish "/users/#{member.id}/timeline/entries/new", {id: id}
  end
end
