class Api::V1::CreditCardsController < Api::V1::ABaseController
  before_filter :load_user!

  def create
    if @user.stripe_customer_id.nil?
      @customer = Stripe::Customer.create(:card => params[:stripeToken],
                                          :email => @user.email,
                                          :description => @user.email)
      @user.update_attribute(:stripe_customer_id, @customer.id)
    else
      @customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
      @card = @customer.cards.create(:card => params[:stripeToken])
      @customer.default_card = @card.id
      @customer.save
    end
    render_success
  end
end
