class ServiceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :member_id, :user_id, :owner_id, :subject_id, :service_type_id, :state,
             :title, :description, :due_at, :created_at, :updated_at,
             :user_facing, :service_request, :service_deliverable, :service_update,
             :owner_full_name, :service_type_name

  delegate :member, :owner, :subject, :service_type, :data_fields, to: :object

  def attributes
    super.tap do |attrs|
      attrs[:service_type] = service_type
      attrs[:owner] = owner.try(:serializer, shallow: true)
      attrs[:member] = member.try(:serializer, shallow: true)
      attrs[:subject] = subject.try(:serializer, shallow: true)
      attrs[:tasks] = service_tasks
      attrs[:data_fields] = data_fields.serializer
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

  def service_tasks
    tasks.order('service_ordinal ASC, due_at DESC, created_at DESC').serializer(for_subject: true)
  end
end
