class TriggerSystemEventJob < Struct.new(:system_event_id)
  def self.create(system_event)
    Delayed::Job.enqueue(new(system_event.id), run_at: system_event.trigger_at)
  end

  def perform
    system_event = SystemEvent.find(system_event_id)
    system_event.trigger! if system_event.trigger_at.try(:<, Time.now)
  end
end
