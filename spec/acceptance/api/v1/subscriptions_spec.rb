require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Subscriptions' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:user) }
  let(:user_id) { user.id }

  post '/api/v1/users/:user_id/subscriptions' do
    example_request '[POST] Create a new subscription for the user' do
      explanation 'Returns the subscription object'
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
    end
  end

  context 'with existing records' do
    let!(:subscription) { create(:user_plan, :user => user) }
    let(:id) { subscription.id }

    describe 'retreiving records' do
      get '/api/v1/users/:user_id/subscriptions' do
        example_request '[GET] Retreive all user subscriptions' do
          explanation 'Returns an array of user plan subscriptions'
          status.should == 200
          parsed_json = JSON.parse(response_body)
          parsed_json.should_not be_empty
        end
      end

      get '/api/v1/users/:user_id/subscriptions/:id' do
        example_request '[GET] Retreive details about a user subscription' do
          explanation 'Returns the subscription object'
          status.should == 200
          parsed_json = JSON.parse(response_body)
          parsed_json.should_not be_empty
        end
      end
    end

    describe 'updating records' do
      put '/api/v1/users/:user_id/subscriptions/:id' do
        example_request '[PUT] Update a subscription for the user' do
          explanation 'Returns the subscription object'
          status.should == 200
          parsed_json = JSON.parse(response_body)
          parsed_json.should_not be_empty
        end
      end

      delete '/api/v1/users/:user_id/subscriptions/:id' do
        example_request '[DELETE] Delete a subscription for the user' do
          explanation 'Returns the subscription object'
          status.should == 200
          parsed_json = JSON.parse(response_body)
          parsed_json.should_not be_empty
        end
      end
    end
  end
end
