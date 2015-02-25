class ScheduledPhoneCallSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :scheduled_at, :created_at, :updated_at, :state
  has_one :user
  has_one :owner
  has_one :phone_call

  def attributes
    if options[:shallow]
      {
        id: object.id,
        owner: object.owner.try(:serializer, options.merge(shallow: true)),
        state: object.state,
        scheduled_at: object.scheduled_at,
        created_at: object.created_at
      }
    else
      super
    end
  end
end
