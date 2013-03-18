require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserWeights" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:each) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    FactoryGirl.create(:user_weight, :user=>@user)
    FactoryGirl.create(:user_weight, :user=>@user)
  end

  get 'api/v1/weights' do
    parameter :auth_token, "User's auth_token"
    required_parameters :auth_token

    let (:auth_token) { @user.auth_token }

    example_request "[GET] Get all user's weights" do
      explanation "Returns an array of weights recorded by the user"
      status.should == 200
      JSON.parse(response_body)['weights'].should be_a Array
    end
  end

  post '/api/v1/weights' do
    parameter :auth_token,    "User's auth token"
    parameter :weight,        "User's weight (kg)"

    required_parameters :auth_token, :weight

    let (:auth_token) { @user.auth_token }
    let (:weight)     { 90 }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "[POST] Set user's weight" do
      explanation "Set the user's weight"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
