require 'spec_helper'
require 'stripe_mock'

describe 'GrantReferrerCreditWhenRefereePayService' do
  let(:referrer) {create(:member)}
  let(:referee) {create(:member, referral_code_id: referral_code.id)}
  let(:referral_code) {create(:referral_code, name: referrer.email, user_id: referrer.id)}

  before do
    StripeMock.start
    referee_customer = Stripe::Customer.create(email: referee.email,
                                               description: StripeExtension.customer_description(referee.id),
                                               card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
    referee.update_attribute(:stripe_customer_id, referee_customer.id)
    referrer_customer = Stripe::Customer.create(email: referrer.email,
                                                description: StripeExtension.customer_description(referrer.id),
                                                card: StripeMock.generate_card_token(last4: "0003", exp_year: 1984))
    referrer.update_attribute(:stripe_customer_id, referrer_customer.id)
  end

  after do
    StripeMock.stop
  end

  describe '#call' do
    before do
      referee_customer = Stripe::Customer.create(email: referee.email,
                                                 description: StripeExtension.customer_description(referee.id),
                                                 card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
      referee.update_attribute(:stripe_customer_id, referee_customer.id)
    end

    def do_method
      event = StripeMock.mock_webhook_event('charge.succeeded', {customer: referee.stripe_customer_id})
      GrantReferrerCreditWhenRefereePayService.new(event).call
    end

    it 'should add the discount to discount_records' do
      expect(referrer.discounts.count).to eq(0)
      do_method
      expect(referrer.discounts.count).to eq(1)
    end
  end
end
