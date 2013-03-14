require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserReadings" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:each) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    @content = FactoryGirl.create(:content)
  end

  get '/api/v1/user_readings' do
    parameter :auth_token,       "User's auth token"
    required_parameters :auth_token

    let (:auth_token)    { @user.auth_token }

    example_request "Get user_readings" do
      explanation "Get user_readings"
      status.should == 200
      JSON.parse(response_body)['user_readings'].should be_a Array
    end
  end

  post '/api/v1/contents/mark_read' do
    parameter :auth_token,       "User's auth token"
    parameter :contents,         "Array of IDs"
    required_parameters :auth_token, :contents

    let (:raw_post)   { {:auth_token=>@user.auth_token, :contents=>[{:id=>1}]}.to_json }  # JSON format request body
    example_request "Mark read user_readings" do
      explanation "Mark current user's readings as read"

      status.should == 200
    end
  end


  post '/api/v1/contents/dismiss' do
    parameter :auth_token,       "User's auth token"
    parameter :contents,         "Array of IDs"
    required_parameters :auth_token, :contents

    let (:raw_post)   { {:auth_token=>@user.auth_token, :contents=>[{:id=>1}]}.to_json }  # JSON format request body
    example_request "Dismiss user_readings" do
      explanation "Dismiss current user's readings"

      status.should == 200
    end
  end

  post '/api/v1/contents/read_later' do
    parameter :auth_token,       "User's auth token"
    parameter :contents,         "Array of IDs"
    required_parameters :auth_token, :contents

    let (:raw_post)   { {:auth_token=>@user.auth_token, :contents=>[{:id=>1}]}.to_json }  # JSON format request body
    example_request "Read later user_readings" do
      explanation "Mark current user's readings as read later"

      status.should == 200
    end
  end

  post '/api/v1/contents/reset' do
    parameter :auth_token,       "User's auth token"
    required_parameters :auth_token

    let (:auth_token)    { @user.auth_token }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "Reset user_readings" do
      explanation "Clears all of the current user's readings"
      status.should == 200
      JSON.parse(response_body)
    end
  end

end
