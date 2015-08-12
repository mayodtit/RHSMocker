class ServiceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :member_id, :user_id, :owner_id, :subject_id,
             :service_type_id, :state, :title, :description, :due_at,
             :created_at, :updated_at, :user_facing, :service_request,
             :service_deliverable, :service_update, :owner_full_name,
             :service_type_name, :time_zone

  delegate :member, :owner, :subject, :service_type, :tasks,
           :data_fields, to: :object

  def attributes
    super.tap do |attrs|
      attrs[:service_type] = service_type.serializer.as_json
      attrs[:member] = member.serializer(shallow: true).as_json
      attrs[:subject] = subject.serializer(shallow: true).as_json
      attrs[:owner] = owner.serializer(shallow: true).as_json

      if options[:include_nested]
        attrs[:tasks] = tasks.serializer.as_json
        attrs[:data_fields] = data_fields.serializer.as_json
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
end
