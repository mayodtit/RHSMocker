class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider, class_name: 'User'
  belongs_to :creator, class_name: 'Member'
  belongs_to :appointment_template
  has_many :appointment_changes
  has_many :system_events
  has_many :phone_numbers, as: :phoneable, dependent: :destroy

  attr_accessor :actor_id, :phone_number

  attr_accessible :user, :user_id, :provider, :provider_id, :scheduled_at, :actor_id, :creator,
                  :creator_id, :arrived_at, :departed_at, :appointment_template_id, :appointment_template,
                  :reason_for_visit, :special_instructions, :phone_number

  validates :user, :provider, :scheduled_at, :creator, presence: true

  after_create :create_events
  after_commit :track_update, on: :update
  after_commit :create_phone_number, on: :create
  after_commit :update_phone_number, on: :update

  def data
    changes = previous_changes.slice(
      :scheduled_at,
      :provider_id,
      :arrival_time,
      :departed_at,
      :reason_for_visit,
      :special_instructions,
      :phone_number
    )
    changes.empty? ? nil : changes
  end

  def track_update
    appointment_changes.create!(actor_id: actor_id, data: data)
  end

  def create_phone_number
    if phone_number
      self.phone_numbers.create!(number: phone_number, primary: false, type: "Work")
    end
  end

  def update_phone_number
    if phone_number
      self.phone_numbers.first.update_attributes!(number: phone_number)
    end
  end

  def create_events
    if appointment_template
      appointment_template.system_event_templates.each do |system_event_template|
        SystemEvent.create!(user: user, system_event_template: system_event_template, appointment_id: self.id, trigger_at: appointment_template.scheduled_at)
      end
    end
  end
end
