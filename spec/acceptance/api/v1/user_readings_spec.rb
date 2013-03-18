require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserReadings" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:each) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    @content = FactoryGirl.create(:content)
    FactoryGirl.create(:user_reading, :user=>@user, :content=>@content)
  end

  get '/api/v1/user_readings' do
    parameter :auth_token,       "User's auth token"
    required_parameters :auth_token

    let (:auth_token)    { @user.auth_token }

    example_request "[GET] Get all user's readings" do
      explanation "Returns an array of the specified user's readings"
      status.should == 200
      JSON.parse(response_body)['user_readings'].should be_a Array
    end
  end

  post '/api/v1/contents/mark_read' do
    parameter :auth_token,  "User's auth token"
    parameter :contents,    "Array of content IDs"
    parameter :id,          "Content ID"
    required_parameters :auth_token, :contents, :id
    scope_parameters :contents, [:id]

    let(:auth_token)  { @user.auth_token }
    let(:contents)    { [{:id=>1}] }
    let (:raw_post)   { params.to_json }  # JSON format request body
    
    example_request "[POST] Mark read user readings" do
      explanation "Mark specified contents as read for this user"

      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  post '/api/v1/contents/dismiss' do
    parameter :auth_token,  "User's auth token"
    parameter :contents,    "Array of content IDs"
    parameter :id,          "Content ID"
    required_parameters :auth_token, :contents, :id
    scope_parameters :contents, [:id]

    let(:auth_token)  { @user.auth_token }
    let(:contents)    { [{:id=>1}] }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "[POST] Dismiss user readings" do
      explanation "Dismiss specified contents for this user"

      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  post '/api/v1/contents/read_later' do
    parameter :auth_token,  "User's auth token"
    parameter :contents,    "Array of content IDs"
    parameter :id,          "Content ID"
    required_parameters :auth_token, :contents, :id
    scope_parameters :contents, [:id]

    let(:auth_token)  { @user.auth_token }
    let(:contents)    { [{:id=>1}] }
    let (:raw_post)   { params.to_json }  # JSON format request body
    example_request "[POST] Read later user readings" do
      explanation "Mark specified content as 'read later' for this user"

      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  post '/api/v1/contents/reset' do
    parameter :auth_token,       "User's auth token"
    required_parameters :auth_token

    let (:auth_token) { @user.auth_token }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "[POST] Reset user readings" do
      explanation "Clears the user's readings list"
      
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
