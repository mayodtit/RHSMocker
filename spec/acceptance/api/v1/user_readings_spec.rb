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
      JSON.parse(response_body)['contents'].should be_a Array
    end
  end

  post '/api/v1/contents/mark_read' do
    # parameter :auth_token,    "User's auth token"
    # parameter :contents,      "User's contents"
    # parameter :id,            "Content ID"
    # scope_parameters :contents, [:id]


    # required_parameters :auth_token, :contents

    # let (:auth_token) { @user.auth_token }
    # let (:id)         { @content.id }
    # let (:raw_post)   { params.to_json }  # JSON format request body

    # example_request "Mark Read a user_reading" do
    #   explanation "Mark a user_reading as Read"
    #   puts response_body
    #   status.should == 200
    #   JSON.parse(response_body)['read_date'].should eq 'read'
    # end
  end

  post '/api/v1/contents/dismiss' do
  end

  post '/api/v1/content/read_later' do
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
