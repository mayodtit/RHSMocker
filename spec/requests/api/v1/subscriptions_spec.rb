require 'spec_helper'
require 'stripe_mock'

describe 'Subscriptions' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }

  before do
    StripeMock.start
    Stripe::Plan.create(amount: 1999,
                        interval: :month,
                        name: 'Single Membership',
                        currency: :usd,
                        id: 'bp20')
    customer = Stripe::Customer.create(email: user.email,
                                       description: StripeExtension.customer_description(user.id),
                                       card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))

    user.update_attribute(:stripe_customer_id, customer.id)
  end

  after do
    StripeMock.stop
  end

  describe 'POST /api/v1/users/:user_id/subscriptions' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/subscriptions", params.merge!(auth_token: session.auth_token,
                                                                   subscription: {plan_id: 'bp20'})
    end

    it 'creates a new subscription' do
      expect(Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.count).to eq(0)
      do_request
      expect(Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.count).to eq(1)
    end

    it 'creates a system message for the user' do
      do_request
      expect(user.master_consult.reload.messages.last.user_id).to eq(Member.robot.id)
      expect(user.master_consult.reload.messages.last.system).to eq(true)
      expect(user.master_consult.reload.messages.last.text).to eq("Thank you for upgrading your subscription to Single Membership.")
    end

    it_behaves_like 'success'
  end
end
