class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider, class_name: 'User'
  belongs_to :creator, class_name: 'Member'
  belongs_to :appointment_template
  has_many :appointment_changes
  has_one :phone_number, as: :phoneable, inverse_of: :phoneable, dependent: :destroy
  has_one :address, inverse_of: :appointment, dependent: :destroy
  has_one :scheduled_at_system_event, class_name: 'SystemEvent',
                                      as: :resource,
                                      conditions: {resource_attribute: :scheduled_at},
                                      dependent: :destroy
  has_one :discharged_at_system_event, class_name: 'SystemEvent',
                                       as: :resource,
                                       conditions: {resource_attribute: :discharged_at},
                                       dependent: :destroy

  attr_accessor :actor_id

  accepts_nested_attributes_for :address, :phone_number

  attr_accessible :user, :user_id, :provider, :provider_id, :scheduled_at, :actor_id, :creator,
                  :creator_id, :arrived_at, :departed_at, :appointment_template_id, :appointment_template,
                  :reason_for_visit, :special_instructions, :address_attributes, :phone_number_attributes

  validates :user, :provider, :scheduled_at, :creator, presence: true
  validates :appointment_template, presence: true, if: :appointment_template_id

  after_save :create_system_events!, on: :create, if: :appointment_template
  after_commit :track_changes

  private

  def create_system_events!
    if appointment_template.scheduled_at_system_event_template && scheduled_at
      self.scheduled_at_system_event = CreateSystemEventsFromTemplatesService.new(user: user, root_system_event_template: appointment_template.scheduled_at_system_event_template, trigger_at: scheduled_at).call
    end
    if appointment_template.discharged_at_system_event_template && departed_at
      self.discharged_at_system_event = CreateSystemEventsFromTemplatesService.new(user: user, root_system_event_template: appointment_template.discharged_at_system_event_template, trigger_at: departed_at).call
    end
  end

  def track_changes
    appointment_changes.create!(actor_id: actor_id, data: data) if data
  end

  def data
    changes = previous_changes.slice(
      :scheduled_at,
      :provider_id,
      :arrival_time,
      :departed_at,
      :reason_for_visit,
      :special_instructions
    )
    changes.empty? ? nil : changes
  end
end
