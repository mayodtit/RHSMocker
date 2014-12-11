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

    it 'update the card when user already have a card' do
      expect(Stripe::Customer.retrieve(user.stripe_customer_id).cards[:data].length).to eq(1)
      do_request
      expect(Stripe::Customer.retrieve(user.stripe_customer_id).cards[:data].length).to eq(1)
      expect(Stripe::Customer.retrieve(user.stripe_customer_id).cards).not_to eq(StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
    end

    it 'creates a system message for the user' do
      do_request
      expect(user.reload.master_consult.messages.last.user_id).to eq(Member.robot.id)
      expect(user.master_consult.messages.last.system).to eq(true)
      expect(user.master_consult.messages.last.text).to eq("Your credit card information has been updated. Payments will now be charged to the card ending in 4242.")
    end

    it_behaves_like 'success'
  end
end
