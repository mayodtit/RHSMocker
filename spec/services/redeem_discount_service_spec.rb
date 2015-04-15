require 'spec_helper'
require 'stripe_mock'

describe 'RedeemDiscountService' do
  describe '#apply_coupon' do
    let(:referrer) {create(:member)}
    let(:referee) {create(:member, referral_code_id: referral_code.id)}
    let(:referral_code) {create(:referral_code, name: referrer.email, user_id: referrer.id)}
    let(:stripe_helper) { StripeMock.create_test_helper }
    let(:credit_card_token) { stripe_helper.generate_card_token }

    before do
      StripeMock.start
      referee_customer = Stripe::Customer.create(email: referee.email,
                                                 description: StripeExtension.customer_description(referee.id),
                                                 card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
      referee.update_attribute(:stripe_customer_id, referee_customer.id)
      Stripe::Plan.create(amount: 19200,
                          interval: :year,
                          name: 'Better Premium, Family Membership',
                          currency: :usd,
                          id: 'bpYRSingle192')
      subscription = CreateStripeSubscriptionService.new(user: referrer, plan_id: 'bpYRSingle192', credit_card_token: credit_card_token).call
      referrer.update_attribute(:stripe_customer_id, subscription.customer)
      event = StripeMock.mock_webhook_event('charge.succeeded', {customer: referee.stripe_customer_id})
      GrantReferrerCreditWhenRefereePayService.new(event).call
    end

    after do
      StripeMock.stop
    end

    context "for recurring invoices" do
      def do_method
        invoice = Stripe::Invoice.create
        event = StripeMock.mock_webhook_event('invoice.created', {id: invoice.id, customer: referrer.stripe_customer_id})
        RedeemDiscountService.new(event: event, status: :recurring).call
      end

      it 'should create an invoice item to deduct the discount amount' do
        do_method
        expect(Stripe::InvoiceItem.all.last.amount).to eq(-19200)
      end

      it 'should time stamp the redeemed_at for the user' do
        do_method
        expect(referrer.reload.discounts.last.redeemed_at).not_to eq(nil)
      end

      it 'should send a confirmation email to user' do
        do_method
        expect(Delayed::Job.count).to eq(1)
      end
    end

    context "for first or updated invoices" do
      def do_method
        RedeemDiscountService.new(member: referrer, status: :first, customer: Stripe::Customer.retrieve(referrer.stripe_customer_id)).call
      end

      it 'should create an invoice item to deduct the discount amount' do
        do_method
        expect(Stripe::InvoiceItem.all.last.amount).to eq(-19200)
      end

      it 'should time stamp the redeemed_at for the user' do
        do_method
        expect(referrer.reload.discounts.last.redeemed_at).not_to eq(nil)
      end

      it 'should send a confirmation email to user' do
        do_method
        expect(Delayed::Job.count).to eq(1)
      end
    end
  end
end
