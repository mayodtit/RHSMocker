class Api::V1::CreditCardsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :render_failure_if_not_self

  def index
    index_resource(@user.credit_cards)
  end

  # since a user is limited to one credit card, this method is used for both
  # adding and updating a credit card
  def create
    @user.remove_all_credit_cards

    begin
      if @user.stripe_customer_id.nil?

        # will raise Stripe::InvalidRequestError: (Status 400) if this fails,
        @customer = Stripe::Customer.create(card: params[:stripe_token],
                                            email: @user.email,
                                            description: StripeExtension.customer_description(@user.id))
        @card = @customer.cards.retrieve(@customer.default_card)
        @user.update_attribute(:stripe_customer_id, @customer.id)
      else
        @customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
        # will raise Stripe::InvalidRequestError: (Status 400) if this fails
        @card = @customer.cards.create(card: params[:stripe_token])
        @customer.save
        Message.create!(message_attributes) if @user.master_consult
        UserMailer.delay.confirm_credit_card_change(@user, @card)
      end

      render_success(credit_card: {type: @card.type,
                                   last4: @card.last4.to_i,
                                   exp_month: @card.exp_month.to_i,
                                   exp_year: @card.exp_year.to_i})
    rescue => e
      Rails.logger.error "Error in CreditCardsController#create for user #{@user.id}: #{e}"
      render_failure({reason: 'Error adding credit card'}, 422)
    end
  end

  private

  def render_failure_if_not_self
    render_failure if (current_user.id != params[:user_id].to_i)
  end

  def message_attributes
    {
      text: "Your credit card information has been updated. Payments will now be charged to the card ending in #{@card.last4.to_i}.",
      user: Member.robot,
      system: true,
      consult: @user.master_consult
    }
  end
end
