require 'spec_helper'
require 'stripe_mock'

describe 'GrantReferrerCreditWhenRefereePay' do
  let(:referrer) {create(:member)}
  let(:referee) {create(:member, referral_code_id: referral_code.id)}
  let(:referral_code) {create(:referral_code, name: referrer.email, user_id: referrer.id)}
  let(:discount_record) { DiscountRecord.new(:discount_record, user_id: referrer.id, coupon: 'OneTimeFiftyPercentOffCoupon', referrer: true)}

  before do
    StripeMock.start
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
      expect(referrer.discount_records.count).to eq(0)
      do_method
      expect(referrer.reload.discount_records.count).to eq(1)
    end
  end

  describe '#apply_coupon' do
    before do
      referrer_customer = Stripe::Customer.create(email: referrer.email,
                                                  description: StripeExtension.customer_description(referrer.id),
                                                  card: StripeMock.generate_card_token(last4: "0003", exp_year: 1984))
      referrer.update_attribute(:stripe_customer_id, referrer_customer.id)
      Stripe::Coupon.create(id: 'OneTimeFiftyPercentOffCoupon', percent_off: 50, duration: 'once')
    end

    def do_method
      event = StripeMock.mock_webhook_event('invoice.created', {customer: referrer.stripe_customer_id})
      GrantReferrerCreditWhenRefereePay.new(event).apply_coupon
    end

    it 'should assign the coupon to referrer‘s stripe discount' do
      expect(Stripe::Customer.retrieve(referrer.stripe_customer_id).discount).to eq(nil)
      do_method
      expect(Stripe::Customer.retrieve(referrer.reload.stripe_customer_id).coupon).to eq('OneTimeFiftyPercentOffCoupon')
    end

    it 'should time stamp the redeemed_at for the user' do
      expect(referrer.discount_records.last.redeemed_at).to eq(nil)
      do_method
      expect(referrer.reload.discount_records.last.redeemed_at).not_to eq(nil)
    end
  end
end
