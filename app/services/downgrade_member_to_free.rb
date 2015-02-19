class DowngradeMemberToFree
  def initialize(event)
    @event = event
  end

  def call
    load_member!
    return if @member.nil?
    @member.downgrade!
    Mails::ConfirmSubscriptionDeletionJob.create(@member.id)
  end

  private

  def load_member!
    customer = @event.data.object.customer
    @member = User.find_by_stripe_customer_id(customer)
  end
end
