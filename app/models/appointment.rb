class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider, class_name: 'User'
  belongs_to :creator, class_name: 'Member'
  belongs_to :appointment_template
  has_many :appointment_changes
  has_many :system_events
  has_one :phone_number, as: :phoneable, inverse_of: :phoneable, dependent: :destroy
  has_one :address, inverse_of: :appointment, dependent: :destroy

  attr_accessor :actor_id

  accepts_nested_attributes_for :address, :phone_number

  attr_accessible :user, :user_id, :provider, :provider_id, :scheduled_at, :actor_id, :creator,
                  :creator_id, :arrived_at, :departed_at, :appointment_template_id, :appointment_template,
                  :reason_for_visit, :special_instructions, :address_attributes, :phone_number_attributes

  validates :user, :provider, :scheduled_at, :creator, presence: true

  after_create :create_events
  after_commit :track_update, on: :update

  def create_events
    if appointment_template
      appointment_template.system_event_templates.each do |system_event_template|
        SystemEvent.create!(user: user, system_event_template: system_event_template, appointment_id: self.id, trigger_at: appointment_template.scheduled_at)
      end
    end
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

  def track_update
    appointment_changes.create!(actor_id: actor_id, data: data)
  end
end
