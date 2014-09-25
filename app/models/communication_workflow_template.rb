class CommunicationWorkflowTemplate < ActiveRecord::Base
  belongs_to :communication_workflow, inverse_of: :communication_workflow_templates
  symbolize :reference_event, in: %i(recipient_free_trial_ends_at), allow_nil: true

  attr_accessible :communication_workflow, :communication_workflow_id,
                  :relative_days, :reference_event

  validates :communication_workflow, :relative_days, presence: true
  validates :relative_days, numericality: {integer_only: true}

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

  def calculated_publish_at(reference_time)
    if relative_days > 0
      relative_days.abs.business_days.after(reference_time.pacific.nine_oclock)
    else
      relative_days.abs.business_days.before(reference_time.pacific.nine_oclock)
    end
  end
end
