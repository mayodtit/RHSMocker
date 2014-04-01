require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'CreditCards' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  let!(:user) { create(:member).tap{|u| u.login} }
  let(:user_id) { user.id }
  let(:auth_token) { user.auth_token }
  let(:card) { double('card', :id => 'card_id', :type => 'Visa', :last4 => '1234', :exp_month => '12', :exp_year => '15') }
  let(:stripe_customer) { double('stripe_customer', :id => 'stripe_id', :default_card => card.id) }

  before do
    stripe_customer.stub_chain(:cards, :retrieve).and_return(card)
  end

  get '/api/v1/users/:user_id/credit_cards' do
    example_request "[GET] List a user's credit cards" do
      explanation "Returns the last four digits of each of the user's credit cards.  Right now the array will always contain one card.  If the user has more than one card on file with Stripe, return the default one"
      status.should == 200
    end
  end

  post '/api/v1/users/:user_id/credit_cards' do
    before(:each) do
      Stripe::Customer.stub(:create => stripe_customer, :retrieve => stripe_customer)
    end

    parameter :stripe_token, 'Stripe CreditCard token'
    required_parameters :stripe_token

    let(:stripe_token) { 'tok_DEADBEEFBAADBEEF' }
    let(:raw_post) { params.to_json }

    example_request '[POST] Add a CreditCard to a member' do
      explanation 'Associate a member with a Stripe CreditCard'
      status.should == 200
    end
  end
end
