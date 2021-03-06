class EntrySerializer < ViewSerializer
  self.root = false

  attributes :id, :created_at, :updated_at, :member_id, :resource_id,
             :resource_type, :phone_call, :actor_id, :data, :image_url

  def attributes
    super.tap do |attributes|
      attributes.merge!(
          member: object.member.try(:serializer, options.merge(shallow: true)),
          actor: object.actor.try(:serializer, options.merge(shallow: true))
      )
    end
  end

  def phone_call
    object.resource.try(:serializer, options.merge(shallow: true)) if object.resource_type == "PhoneCall"
  end

  def image_url
    object.resource.try(:image_url) if object.resource.try(:respond_to?, :image_url)
  end
end
