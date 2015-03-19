class ServiceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :user_request, :due_at, :service_type_id, :created_at, :owner_id, :user_facing, :member_id, :subject_id, :service_template_id

  def attributes
    if options[:shallow]
      attributes = {
          id: object.id,
          title: object.title,
          description: object.description,
          user_request: object.user_request,
          service_type_id: object.service_type_id,
          due_at: object.due_at,
          user_facing: object.user_facing,
          created_at: object.created_at,
          subject: object.subject.try(:serializer, options.merge(shallow: true)),
          member: object.member.try(:serializer, options.merge(shallow: true))
      }
    elsif options[:for_subject]
      attributes = {
          id: object.id,
          title: object.title,
          description: object.description,
          user_request: object.user_request,
          service_type_id: object.service_type_id,
          due_at: object.due_at,
          created_at: object.created_at,
          service_type: object.service_type,
          user_facing: object.user_facing,
          owner: object.owner.try(:serializer, options.merge(shallow: true)),
          member: object.member.try(:serializer, options.merge(shallow: true)),
          subject: object.subject.try(:serializer, options.merge(shallow: true))
      }
      attributes[:tasks] = object.tasks.try(:serializer, options) if object.respond_to? :tasks
    else
      super.tap do |attributes|
        attributes.merge!(
            owner: object.owner.try(:serializer, options.merge(shallow: true)),
            member: object.member.try(:serializer, options.merge(shallow: true)),
            subject: object.subject.try(:serializer, options.merge(shallow: true)),
            service_type: object.service_type
        )
        attributes[:tasks] = object.tasks.try(:serializer, options.merge(shallow: true)) if object.respond_to? :tasks
      end
    end
  end
end