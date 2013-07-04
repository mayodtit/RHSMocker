require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserWeights" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:user) }
  let(:auth_token) { user.auth_token }

  before(:each) do
    user.login
  end

  parameter :auth_token, "User's auth_token"
  required_parameters :auth_token

  get '/api/v1/users/:user_id/weights' do
    let!(:user_weight) { create(:user_weight, :user => user) }

    parameter :user_id, "User ID for which to get weights"
    required_parameters :user_id
    let(:user_id) { user.id }

    example_request "[GET] Get all weights for a user" do
      explanation "Returns an array of weights recorded by the user"
      status.should == 200
      JSON.parse(response_body)['user_weights'].should be_a Array
    end
  end

  post '/api/v1/users/:user_id/weights' do
    let!(:user_weight) { build(:user_weight, :user => user) }

    parameter :user_id, "User ID for which to get weights"
    parameter :weight, "User's weight (kg)"
    parameter :taken_at, "DateTime of when the reading was taken"
    required_parameters :user_id, :weight, :taken_at

    let(:user_id) { user.id }
    let(:weight) { 90 }
    let(:taken_at) { DateTime.now-20.minutes }
    let(:raw_post) { params.to_json }

    example_request "[POST] Set user's weight" do
      explanation "Set the user's weight"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  delete '/api/v1/users/:user_id/weights/:id' do
    let!(:user_weight) { create(:user_weight, :user => user) }

    parameter :user_id, "User ID for which to get weights"
    parameter :id, "Weight ID to delete"
    required_parameters :user_id, :id

    let(:user_id) { user.id }
    let(:id) { user_weight.id }
    let(:raw_post) { params.to_json }

    example_request "[DELETE] Remove user's user weight reading" do
      explanation "Remove user's user weight reading"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end
