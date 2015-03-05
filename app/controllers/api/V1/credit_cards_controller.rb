class Api::V1::CreditCardsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :render_failure_if_not_self
  before_filter :remove_credit_cards, :only => :create

  def index
    index_resource(@user.credit_cards)
  end

  # since a user is limited to one credit card, this method is used for both
  # adding and updating a credit card
  def create
    begin
      if @user.stripe_customer_id.nil?

        # will raise Stripe::InvalidRequestError: (Status 400) if this fails,
        @customer = Stripe::Customer.create(card: params[:stripe_token],
                                            email: @user.email,
                                            description: StripeExtension.customer_description(@user.id))
        load_credit_card!
        @user.update_attribute(:stripe_customer_id, @customer.id)
      else
        load_customer!
        # will raise Stripe::InvalidRequestError: (Status 400) if this fails
        @card = @customer.cards.create(card: params[:stripe_token])
        @customer.save
        send_confirmation_info
      end

      render_success(credit_card: {type: @card.type,
                                   last4: @card.last4.to_i,
                                   exp_month: @card.exp_month.to_i,
                                   exp_year: @card.exp_year.to_i})
    rescue Stripe::CardError => e
      Rails.logger.error "Error in subscriptionsController#create for user #{@user.id}: #{e}"
      render_failure({reason: e.as_json['message']}, 422) and return
    rescue => e
      Rails.logger.error "Error in CreditCardsController#create for user #{@user.id}: #{e}"
      render_failure({reason: 'Error adding credit card'}, 422) and return
    end
  end

  private
  def remove_credit_cards
    @user.remove_all_credit_cards
  end

  def load_credit_card!
    @card = @customer.cards.retrieve(@customer.default_card)
  end

  def load_customer!
    @customer = Stripe::Customer.retrieve(@user.stripe_customer_id) if @user
  end

  def send_confirmation_info
    Message.create!(message_attributes) if @user.master_consult
    UserMailer.delay.confirm_credit_card_change(@user, @card)
  end

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
