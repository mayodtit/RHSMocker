require 'spec_helper'
require 'stripe_mock'

describe '#set_user_delinquent_stats' do
  let!(:user) {create(:member, :premium)}
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

  describe '#call' do

    def charge_failed
      event = StripeMock.mock_webhook_event('charge.failed', {customer: user.stripe_customer_id})
      SetDelinquentStatus.new( event ).call
    end

    def charge_succeeded
      event = StripeMock.mock_webhook_event('charge.succeeded', {customer: user.stripe_customer_id})
      SetDelinquentStatus.new(event).call
    end

    context 'user is currently not delinquent' do
      it 'should set user delinquent status to true if the charge failed' do
        expect{ charge_failed }.to change{ user.reload.delinquent }.from( false ).to ( true )
      end

      it 'should not change user delinquent status to true if the charge succeeded' do
        charge_succeeded
        expect( user.reload.delinquent ).to eq( false )
      end
    end

    context 'user is currently delinquent' do
      before do
        user.update_attributes(:delinquent => true)
      end

      it 'should set user delinquent status to false if charge succeeded' do
        expect{charge_succeeded}.to change{ user.reload.delinquent }.from( true ).to ( false )
      end

      it 'should not change user delinquent status to false if charge failed' do
        charge_failed
        expect( user.reload.delinquent ).to eq( true )
      end
    end
  end
end