class AdjustServiceLevelService
  def initialize(event)
    @user = User.find_by_stripe_customer_id(event.data.object.customer)
  end

  def call
    return if @user.nil?
    @user.update_attributes(status: 'premium') if (@user.free? || @user.trial?)
  end
end
