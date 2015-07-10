class TaskSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at, :type, :created_at,
             :owner_id, :service_type_id, :triage_state, :member_id,
             :day_priority, :task_template_id, :urgent, :unread, :follow_up,
             :modal_template, :service_title, :queue

  delegate :member, :owner, :service_type, :task_changes, :task_steps,
           :task_template, :input_data_fields, :output_data_fields,
           :service, to: :object

  def attributes
    super.tap do |attrs|
      attrs[:member] = member.try(:serializer, shallow: true)
      attrs[:owner] = owner.try(:serializer, shallow: true)
      attrs[:service_type] = service_type
      attrs[:task_steps] = task_steps.serializer.as_json
      attrs[:service_data_fields] = service.try(:data_fields).try(:serializer).try(:as_json)
      attrs[:input_data_fields] = input_data_fields.serializer.as_json
      attrs[:output_data_fields] = output_data_fields.serializer.as_json
      attrs[:task_changes] = task_changes.try(:serializer, shallow: true)
    end
  end

  def type
    'task'
  end

  def triage_state
    '-'
  end

  def modal_template
    task_template.try(:modal_template)
  end

  def service_title
    service.try(:title)
  end
end
