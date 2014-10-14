class DeliverScheduledCommunicationJob < Struct.new(:scheduled_communication_id, :run_at)
  def self.create(scheduled_communication_id, run_at)
    Delayed::Job.enqueue(new(scheduled_communication_id), queue: 'scheduled_communications', run_at: run_at)
  end

  def perform
    sc = ScheduledCommunication.find(scheduled_communication_id)
    return unless sc.publish_at_past_time?
    if sc.held?
      sc.cancel!
    elsif sc.scheduled?
      sc.deliver!
    end
  end
end
