class CommunicationWorkflowTemplate < ActiveRecord::Base
  belongs_to :communication_workflow, inverse_of: :communication_workflow_templates
  symbolize :reference_event, in: %i(recipient_free_trial_ends_at), allow_nil: true

  attr_accessible :communication_workflow, :communication_workflow_id,
                  :relative_days, :relative_hours, :reference_event

  validates :communication_workflow, :relative_days, :relative_hours, presence: true
  validates :relative_days, :relative_hours, numericality: {integer_only: true}

  before_validation :set_defaults

  protected

  def reference_attributes(member)
    case reference_event
    when :recipient_free_trial_ends_at
      {
        reference: member,
        reference_event: :free_trial_ends_at,
        relative_days: relative_days
      }
    else
      {}
    end
  end

  def calculated_publish_at(reference, reference_time)
    case reference_event
    when :recipient_free_trial_ends_at
      relative_publish_at(reference.free_trial_ends_at)
    else
      relative_publish_at(reference_time)
    end
  end

  def relative_publish_at(reference_time)
    if (relative_days == 0) && reference_event.nil?
      # TODO - hack. reference time is set to the previous business day, but we want the current time
      if relative_hours > 0
        if (Time.now + relative_hours.hours + 1.hour).business_time?
          if (Time.now + relative_hours.hours) > 1.business_day.after(reference_time.pacific.eight_oclock) && (Time.now + relative_hours.hours) < 1.business_day.after(reference_time.pacific.eight_oclock)
            #if sending between 8-9am, send at 10am
            1.business_day.after(reference_time.pacific.ten_oclock)
          elsif (Time.now + relative_hours.hours) >= 1.business_day.after(reference_time.pacific.nine_oclock)
            # if sending after 9AM, delay 1 hour
            Time.now + relative_hours.hours
          else
            # if before 8AM, send at 9AM
            1.business_day.after(reference_time.pacific.nine_oclock)
          end
        else
          # during off hours, roll forward to the next day
          1.business_day.after(reference_time.pacific.nine_oclock)
        end
      else
        relative_hours.abs.business_hours.before(Time.now.pacific)
      end
    elsif relative_days > 0
      relative_days.abs.business_days.after(reference_time.pacific.nine_oclock)
    else
      relative_days.abs.business_days.before(reference_time.pacific.nine_oclock)
    end
  end

  def set_defaults
    self.relative_hours ||= 0
    true
  end
end
