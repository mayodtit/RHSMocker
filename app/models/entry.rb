class Entry < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  belongs_to :member
  belongs_to :actor, class_name: "Member"
  serialize :data, Hash

  validates :member, :resource, presence: true
  attr_accessor :pubsub_client_id
  attr_accessible :resource, :resource_id, :member, :member_id, :resource_type, :actor, :actor_id, :data, :pubsub_client_id

  after_validation :set_created_at, on: :create
  after_commit :publish, on: :create

  def publish
    PubSub.publish "/members/#{member.id}/timeline/entries/new", {id: id}, pubsub_client_id
  end

  def set_created_at
    self.created_at ||= resource.created_at
  end

  def self.before(time=nil)
    time ? where('created_at <= ?', time) : scoped
  end

  def self.after(time=nil)
    time ? where('created_at >= ?', time) : scoped
  end

end
