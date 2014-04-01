class Api::V1::CreditCardsController < Api::V1::ABaseController
  before_filter :load_user!

  def index
    render json: @user.credit_cards
  end

  def create
    if @user.credit_cards.count == 0
      begin
        if @user.stripe_customer_id.nil?

          # will raise Stripe::InvalidRequestError: (Status 400) if this fails,
          @customer = Stripe::Customer.create(card: params[:stripe_token],
                                              email: @user.email,
                                              description: @user.email)
          @card = @customer.cards.retrieve(@customer.default_card)
          @user.update_attribute(:stripe_customer_id, @customer.id)
        else
          @customer = Stripe::Customer.retrieve(@user.stripe_customer_id)

          # will raise Stripe::InvalidRequestError: (Status 400) if this fails
          @card = @customer.cards.create(card: params[:stripe_token])
          @customer.save
        end
        render_success(credit_card: {type: @card.type,
                                     last4: @card.last4.to_i,
                                     exp_month: @card.exp_month.to_i,
                                     exp_year: @card.exp_year.to_i})
      rescue => e
        Rails.logger.error "Error in CreditCardsController#create for user #{@user.id}: #{e}"
        render_failure({reason: 'Error adding credit card'}, 422)
      end
    else
      render_failure({reason: 'User can only have one credit card on file'}, 422)
    end
  end
end
