class ServiceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at, :service_type_id, :created_at, :owner_id, :user_id

  def attributes
    if options[:shallow]
      attributes = {
          id: object.id,
          user_id: object.member_id,
          title: object.title,
          description: object.description,
          service_type_id: object.service_type_id,
          due_at: object.due_at,
          created_at: object.created_at,
      }
    elsif options[:for_subject]
      attributes = {
          id: object.id,
          user_id: object.user_id,
          title: object.title,
          description: object.description,
          service_type_id: object.service_type_id,
          due_at: object.due_at,
          created_at: object.created_at,
          service_type: object.service_type,
          owner: object.owner.try(:serializer, options.merge(shallow: true))
      }
      attributes[:tasks] = object.tasks.try(:serializer, options) if object.respond_to? :tasks
    else
      super.tap do |attributes|
        attributes.merge!(
            owner: object.owner.try(:serializer, options),
            service_type: object.service_type
        )
        attributes[:tasks] = object.tasks.try(:serializer, options.merge(shallow: true)) if object.respond_to? :tasks
      end
    end
  end

  private

  def user_id
    object.member_id
  end
end
