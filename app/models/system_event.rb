class SystemEvent < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :system_event_template, inverse_of: :system_events
  has_one :system_action, inverse_of: :system_event

  attr_accessible :user, :user_id, :system_event_template, :system_event_template_id, :trigger_at, :state

  validates :user, :system_event_template, :trigger_at, presence: true

  private

  state_machine initial: :scheduled do
    event :trigger do
      transition :scheduled => :triggered
    end

    event :cancel do
      transition :scheduled => :canceled
    end
  end
end
