class Mail::NotifyTrialWillEndJob < Struct.new(customer = event.data.object.customer)
  def self.create
    Delayed::Job.enqueue(new(event))
  end

  def perform

  end
end