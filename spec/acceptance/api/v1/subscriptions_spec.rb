require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Subscriptions' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member, :with_stripe_customer_id) }
  let!(:plan) { create(:plan) }
  let(:user_id) { user.id }
  let(:auth_token) { user.auth_token }

  before do
    Subscription.any_instance.stub(:stripe_ids_present)
    Subscription.any_instance.stub(:subscribe_with_stripe!)
    Subscription.any_instance.stub(:set_user_to_premium!)
  end

  parameter :auth_token, "Performing user's auth_token"
  parameter :user_id, "Target user's id"
  required_parameters :auth_token, :user_id

  # context 'creating a subscription' do
  #   post '/api/v1/users/:user_id/subscriptions' do
  #     parameter :subscription, 'Contains subscription information'
  #     parameter :plan_id, 'Plan ID for subscription'
  #
  #     required_parameters :subscription, :plan_id
  #
  #     let(:subscription) { {:plan_id => plan.id} }
  #     let(:raw_post) { params.to_json }
  #
  #     example_request '[POST] Create a new subscription for the user' do
  #       explanation 'Returns the subscription object'
  #       status.should == 200
  #       parsed_json = JSON.parse(response_body)
  #       parsed_json.should_not be_empty
  #     end
  #   end
  # end

  # context 'with existing records' do
  #   let!(:subscription) { create(:subscription, :user => user, :plan => plan) }
  #   let(:id) { subscription.id }
  #
  #   get '/api/v1/users/:user_id/subscriptions' do
  #     example_request '[GET] Retreive all user subscriptions' do
  #       explanation 'Returns an array of user plan subscriptions'
  #       status.should == 200
  #       parsed_json = JSON.parse(response_body)
  #       parsed_json.should_not be_empty
  #     end
  #   end
  #
  #   get '/api/v1/users/:user_id/subscriptions/:id' do
  #     example_request '[GET] Retreive details about a user subscription' do
  #       explanation 'Returns the subscription object'
  #       status.should == 200
  #       parsed_json = JSON.parse(response_body)
  #       parsed_json.should_not be_empty
  #     end
  #   end

   #put '/api/v1/users/:user_id/subscriptions/:id' do
   #  example_request '[PUT] Update a subscription for the user' do
   #    explanation 'Returns the subscription object'
   #    status.should == 200
   #    parsed_json = JSON.parse(response_body)
   #    parsed_json.should_not be_empty
   #  end
   #end

end
