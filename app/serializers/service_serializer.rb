class ServiceSerializer < ActiveModel::Serializer
  self.root = false

  delegate :member, :owner, :service_type, to: :object

  attributes :id, :member_id, :user_id, :owner_id, :subject_id, :service_type_id, :state,
             :title, :description, :due_at, :created_at, :updated_at,
             :user_facing, :service_request, :service_deliverable, :service_update,
             :owner_full_name, :service_type_name

  def attributes
    super.tap do |attrs|
      if for_subject?
        attrs.merge!(subject_attributes)
      elsif non_shallow? # KC - TODO - invert this logic, shallow should be default
        attrs.merge!(non_shallow_attributes)
      end
    end
  end

  private

  alias_method :user_id, :member_id

  def owner_full_name
    owner.try(:full_name)
  end

  def service_type_name
    service_type.try(:name)
  end

  def for_subject?
    options[:for_subject] ? true : false
  end

  def non_shallow?
    options[:shallow].blank? ? true : false
  end

  def for_activity?
    options[:for_activity] ? true : false
  end

  def subject_attributes
    {
      service_type: service_type,
      owner: owner.try(:serializer, options.merge(shallow: true)),
      member: member.try(:serializer, options.merge(shallow: true)),
      tasks: tasks
    }
  end

  def non_shallow_attributes
    {
      service_type: service_type,
      owner: owner.try(:serializer, options),
      member: member.try(:serializer, options),
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
