require 'spec_helper'
require 'stripe_mock'

describe 'OfferFreeMonthToReferrerWhenRefereePay' do
  before do
    StripeMock.start
  end

  after do
    StripeMock.stop
  end

  describe '#assign_coupon' do
    let(:referrer) {create(:member)}
    let(:referee) {create(:member, referral_code_id: referral_code.id)}
    let(:referral_code) {create(:referral_code, name: referrer.email, user_id: referrer.id)}

    before do
      referee_customer = Stripe::Customer.create(email: referee.email,
                                                 description: StripeExtension.customer_description(referee.id),
                                                 card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
      referee.update_attribute(:stripe_customer_id, referee_customer.id)
    end

    def do_method
      event = StripeMock.mock_webhook_event('charge.succeeded', {customer: referee.stripe_customer_id})
      OfferFreeMonthToReferrerWhenRefereePay.new(event).assign_coupon
    end

    it 'should increase the quantity of referrer‘s coupon number by 1' do
      expect(referrer.coupon_number).to eq(0)
      do_method
      expect(referrer.reload.coupon_number).to eq(1)
    end

    it 'should remove the referee‘s referral code id' do
      expect(referee.referral_code_id).to eq(referral_code.id)
      do_method
      expect(referee.reload.referral_code_id).to eq(nil)
    end
  end

  describe '#redeem_coupon' do
    let(:referrer) {create(:member, coupon_number:1)}

    before do
      referrer_customer = Stripe::Customer.create(email: referrer.email,
                                                  description: StripeExtension.customer_description(referrer.id),
                                                  card: StripeMock.generate_card_token(last4: "0003", exp_year: 1984))
      referrer.update_attribute(:stripe_customer_id, referrer_customer.id)
      Stripe::Coupon.create(id: 'OneTimeFiftyPercentOffCoupon', percent_off: 50, duration: 'once')
    end

    def do_method
      event = StripeMock.mock_webhook_event('invoice.created', {customer: referrer.stripe_customer_id})
      OfferFreeMonthToReferrerWhenRefereePay.new(event).apply_coupon
    end

    it 'should assign the coupon to referrer‘s stripe discount' do
      expect(Stripe::Customer.retrieve(referrer.stripe_customer_id).discount).to eq(nil)
      do_method
      expect(Stripe::Customer.retrieve(referrer.reload.stripe_customer_id).coupon).to eq('OneTimeFiftyPercentOffCoupon')
    end

    it 'should decrease the referrer‘ coupon number by 1' do
      expect(referrer.coupon_number).to eq(1)
      do_method
      expect(referrer.reload.coupon_number).to eq(0)
    end
  end
end
