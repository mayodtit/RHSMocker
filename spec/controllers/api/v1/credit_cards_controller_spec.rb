require 'spec_helper'

describe Api::V1::CreditCardsController do
  let(:card) { double('card', :id => 'card_id', :type => 'Visa', :last4 => '1234', :exp_month => '12', :exp_year => '15') }
  let(:stripe_customer) { double('stripe_customer', :id => 'stripe_id', :default_card => card.id) }
  let(:user) { create(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
    Stripe::Customer.stub(:create => stripe_customer, :retrieve => stripe_customer)
    stripe_customer.stub_chain(:cards, :retrieve).and_return(card)
  end

  describe 'POST create' do
    def do_request
      post :create
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      context 'user without stripe id' do
        it 'creates a stripe customer' do
          Stripe::Customer.should_receive(:create).once
          do_request
        end

        it 'sets the stripe_customer_id' do
          user.stripe_customer_id.should be_nil
          do_request
          user.reload.stripe_customer_id.should == stripe_customer.id
        end

        it_behaves_like 'success'
      end

      context 'user with stripe id' do
        let(:card) { double('card', :id => 'card_id') }
        let(:cards) { double('cards', :create => card, :retrieve => card) }

        before(:each) do
          user.stub(:stripe_customer_id => stripe_customer.id)
          stripe_customer.stub(:cards => cards,
                               :default_card= => true,
                               :save => true)
        end

        xit 'adds a card to the customer' do
          cards.should_receive(:create).once
          do_request
        end

        xit 'sets the default card' do
          stripe_customer.should_receive(:default_card=).once
          stripe_customer.should_receive(:save).once
          do_request
        end

        # it_behaves_like 'success'
      end
    end
  end
end
