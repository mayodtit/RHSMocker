class Api::V1::CreditCardsController < Api::V1::ABaseController
  before_filter :load_user!

  def index
    render json: @user.credit_cards
  end

  def create
    if @user.stripe_customer_id.nil?
      @customer = Stripe::Customer.create(card: params[:stripe_token],
                                          email: @user.email,
                                          description: @user.email)
      @user.update_attribute(:stripe_customer_id, @customer.id)
    else
      @customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
      @card = @customer.cards.create(card: params[:stripe_token])
      @customer.default_card = @card.id
      @customer.save
    end
    render_success
  end
end
