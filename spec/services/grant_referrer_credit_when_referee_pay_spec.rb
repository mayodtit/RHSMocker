require 'spec_helper'
require 'stripe_mock'

describe 'GrantReferrerCreditWhenRefereePay' do
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
    Stripe::Coupon.create(id: 'ONE_TIME_HUNDRED_PERCENT_OFF_COUPON_CODE', percent_off: 100, duration: 'once')
  end

  after do
    StripeMock.stop
  end

  describe '#assign_coupon' do
    before do
      referee_customer = Stripe::Customer.create(email: referee.email,
                                                 description: StripeExtension.customer_description(referee.id),
                                                 card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
      referee.update_attribute(:stripe_customer_id, referee_customer.id)
    end

    def do_method
      event = StripeMock.mock_webhook_event('charge.succeeded', {customer: referee.stripe_customer_id})
      GrantReferrerCreditWhenRefereePay.new(event).assign_coupon
    end

    it 'should add the discount to discount_records' do
      expect(referrer.discounts.count).to eq(0)
      do_method
      expect(referrer.discounts.count).to eq(1)
    end
  end

  describe '#apply_coupon' do
    before do
      event = StripeMock.mock_webhook_event('charge.succeeded', {customer: referee.stripe_customer_id})
      GrantReferrerCreditWhenRefereePay.new(event).assign_coupon
    end

    def do_method
      event = StripeMock.mock_webhook_event('invoice.created', {customer: referrer.stripe_customer_id})
      GrantReferrerCreditWhenRefereePay.new(event).apply_coupon
    end

    it 'should create an invoice item under the created invoice to add the discount' do
      expect(referrer.discounts.first.invoice_item_id).to eq(nil)
      do_method
      expect(referrer.discounts.first.invoice_item_id).not_to eq(nil)
    end

    it 'should time stamp the redeemed_at for the user' do
      expect(referrer.discounts.last.redeemed_at).to eq(nil)
      do_method
      expect(referrer.reload.discounts.last.redeemed_at).not_to eq(nil)
    end

    it 'should send a confirmation email to user' do
      do_method
      expect(Delayed::Job.count).to eq(1)
    end
  end
end
