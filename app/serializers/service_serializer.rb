class ServiceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :member_id, :user_id, :owner_id, :service_type_id, :state,
             :title, :description, :due_at, :created_at, :updated_at,
             :user_facing, :service_request, :service_deliverable

  def attributes
    if for_activity?
      activity_attributes
    else
      super.tap do |attrs|
        if for_subject?
          attrs.merge!(subject_attributes)
        elsif non_shallow? # KC - TODO - invert this logic, shallow should be default
          attrs.merge!(non_shallow_attributes)
        end
      end
    end
  end

  private

  def for_subject?
    options[:for_subject] ? true : false
  end

  def non_shallow?
    options[:shallow].blank? ? true : false
  end

  def for_activity?
    options[:for_activity] ? true : false
  end

  def user_id
    object.member_id
  end

  def activity_attributes
    {
        id: object.id,
        state: object.state,
        title: object.title,
        description: object.service_request,
        due_at: object.due_at,
        updated_at: object.updated_at,
        owner_id: object.owner_id,
        deliverable: object.deliverable
    }
  end

  def subject_attributes
    {
      service_type: object.service_type,
      owner: object.owner.try(:serializer, options.merge(shallow: true)),
      member: object.member.try(:serializer, options.merge(shallow: true)),
      tasks: tasks
    }
  end

  def non_shallow_attributes
    {
      service_type: object.service_type,
      owner: object.owner.try(:serializer, options),
      member: object.member.try(:serializer, options),
      tasks: tasks
    }
  end

  def tasks
    if object.respond_to? :tasks
      object.tasks.order('service_ordinal ASC, due_at DESC, created_at DESC').try(:serializer, options.merge(for_subject: true))
    else
      nil
    end
  end
end
