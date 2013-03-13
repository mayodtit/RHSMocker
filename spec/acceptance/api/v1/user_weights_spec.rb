require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserWeights" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:each) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
  end

  post '/api/v1/weights' do
    parameter :auth_token,    "User's auth token"
    parameter :weight,        "User's weight"

    required_parameters :auth_token, :weight

    let (:auth_token) { @user.auth_token }
    let (:weight)     { 90 }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "Set user's weight" do
      explanation "Set the current user's weight by kg"
      status.should == 200
      JSON.parse(response_body)
    end
  end

  get 'api/v1/weights' do
    parameter :auth_token, "User's auth_token"

    required_parameters :auth_token

    let (:auth_token) { @user.auth_token }

    example_request "Get all user weights" do
      explanation "Get all user weights"

      status.should == 200
    end
  end
end
