class EntrySerializer < ViewSerializer
  self.root = false

  attributes :id, :created_at, :updated_at, :member_id, :resource_id, :resource_type, :actor_id

  def attributes
    if options[:shallow]
      attributes = {
          id: object.id,
          created_at: object.created_at,
          updated_at: object.updated_at,
          member_id: object.member_id,
          actor_id: object.actor_id,
          resource_id: object.resource_id,
          resource_type: object.resource_type
      }
      attributes
    elsif options[:timeline]
      attributes = {
          id: object.id,
          created_at: object.created_at,
          updated_at: object.updated_at,
          resource: object.resource.try(:serializer),
          resource_type: object.resource_type,
          member: object.member.try(:serializer, options.merge(shallow: true)),
          member_id: object.member_id,
          actor: object.actor.try(:serializer, options.merge(shallow: true)),
          actor_id: object.actor_id

      }
      attributes
    else
      super.tap do |attributes|
        attributes.merge!(
            resource: object.resource.try(:serializer, options.merge(shallow: true))
        )
      end
    end
  end
end
