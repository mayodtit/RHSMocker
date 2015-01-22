class Entry < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  belongs_to :member

  validates :member, :resource, presence: true

  after_commit :publish, on: :create

  def publish
    PubSub.publish "/users/#{user.id}/timeline/entries/new", {id: id}
  end
end
