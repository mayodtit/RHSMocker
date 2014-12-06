require 'spec_helper'
require 'stripe_mock'

describe 'credit cards' do
  let!(:user) { create(:member, :premium) }
  let!(:session) { user.sessions.create }
  before do
    StripeMock.start
    customer = Stripe::Customer.create(email: user.email,
                                       description: StripeExtension.customer_description(user.id),
                                      card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
    user.update_attribute(:stripe_customer_id, customer.id)
  end

  after do
    StripeMock.stop
  end

  describe 'POST /api/v1/users/:user_id/credit_cards' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/credit_cards", params.merge!(auth_token: session.auth_token,
                                                                  stripe_token: StripeMock.generate_card_token(last4: "4242", exp_year: 1994))
    end

    it 'send confirmation email to user when changes the credit card' do
      UserMailer.should_receive :confirm_credit_card_change
      do_request
    end

    it_behaves_like 'success'
  end
end