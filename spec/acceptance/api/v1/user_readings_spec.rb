require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserReadings" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:each) do
    @user = FactoryGirl.create(:user_with_email)

  end

  get '/api/v1/user_readings?auth_token=:auth_token' do
    parameter :auth_token,       "User's auth token"

    let (:auth_token)    { @user.auth_token }

    example_request "Get user_readings" do
      explanation "Get user_readings"

      status.should == 200
    end
  end
end