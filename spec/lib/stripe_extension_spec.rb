require './lib/stripe_extension.rb'

module Rails; end # to avoid loading the rails env

describe StripeExtension do
  describe '#plan_serializer' do
    before do
      @stripe_plan = double()
      @stripe_plan.stub(:id).and_return(1)
      @stripe_plan.stub(:name).and_return('plan')
      @stripe_plan.stub(:price).and_return('1337')
    end

    context 'without metadata' do
      it 'returns Stripe plan hash' do
        @stripe_plan.stub(:metadata).and_return({})
        expected_hash = {
          id: 1,
          name: 'plan',
          price: '$13.37/month',
          description: nil
        }

        hash = StripeExtension.plan_serializer(@stripe_plan)
        hash.should eq(expected_hash)
      end
    end

    context 'with metadata' do
      it 'returns Stripe plan hash' do
        @stripe_plan.stub(:metadata).and_return({
          display_name: 'p',
          display_price: '$313.37 USD/month'
        })

        expected_hash = {
          id: 1,
          name: 'p',
          price: '$313.37 USD/month',
          description: nil
        }

        hash = StripeExtension.plan_serializer(@stripe_plan)
        hash.should eq(expected_hash)
      end
    end
  end

  describe '#customer_description' do
    context 'RAILS_ENV is production' do
      it 'returns a description for the customer' do
        Rails.stub_chain(:env, :production?).and_return(true)
        str = StripeExtension.customer_description(1)
        str.should eq('User 1')
      end
    end

    context 'RAILS_ENV is not production' do
      it 'returns a desciption for the customer with the RAILS_ENV and hostname appended' do
        Rails.stub(:env).and_return('test123')
        Rails.stub_chain(:env, :production?).and_return(false)
        Socket.stub(:gethostname).and_return('testserver')
        str = StripeExtension.customer_description(1)
        str.should eq('User 1 on test123 (testserver)')
      end
    end
  end
end
