require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserReadings" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login

    # to test mark_read, dismiss, and read_later
    @content = FactoryGirl.create(:content)

    # to test inbox
    consult = FactoryGirl.create(:consult)
    content = FactoryGirl.create(:content)

    # unread messages and contents
    7.times do
      message = FactoryGirl.create(:message, :consult=>consult, :user=>@user)
      FactoryGirl.create(:message_status, :user=>@user, :message=>message, :status=>'unread')
      FactoryGirl.create(:user_reading, :user=>@user)
    end

    # read messages and contents
    30.times do
      message = FactoryGirl.create(:message, :consult=>consult, :user=>@user)
      FactoryGirl.create(:message_status, :user=>@user, :message=>message, :status=>'read')
      FactoryGirl.create(:user_reading, :user=>@user, :read_date=>Date.today())
    end
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

  get '/api/v1/inbox' do
    parameter :auth_token,       "User's auth token"
    required_parameters :auth_token

    let (:auth_token)    { @user.auth_token }

    example_request "[GET] Get all inbox items (messages and content)" do
      explanation "Returns two arrays (read, and unread) of the specified user's readings and messages. Returns only 10 most recent 'read' items (defaults to page=1 and number_per_page=10)."
      status.should == 200
      JSON.parse(response_body)['unread'].should be_a Array
      JSON.parse(response_body)['read'].should be_a Array
    end
  end

  get '/api/v1/inbox/:page' do
    parameter :auth_token,       "User's auth token"
    parameter :page,             "Page number"
    required_parameters :auth_token, :page

    let(:auth_token)    { @user.auth_token }
    let(:page)          { 2 }

    example_request "[GET] Get all of inbox items (messages and content), and specific page of read items" do
      explanation "Returns two arrays (read and unread) of the specified user's readings and messages. Returns only 10 items on that page (defaults to number_per_page=10)."
      status.should == 200
      JSON.parse(response_body)['unread'].should be_a Array
      JSON.parse(response_body)['read'].should be_a Array
    end
  end

  get '/api/v1/inbox/:page/:per_page' do
    parameter :auth_token,       "User's auth token"
    parameter :page,             "Page number"
    parameter :per_page,         "Items per page"
    required_parameters :auth_token, :page, :per_page

    let(:auth_token)    { @user.auth_token }
    let(:page)          { 2 }
    let(:per_page)      { 5 }

    example_request "[GET] Get all of inbox items (messages and content), items per page" do
      explanation "Returns two arrays (read and unread) of the specified user's readings and messages"
      status.should == 200
      JSON.parse(response_body)['unread'].should be_a Array
      JSON.parse(response_body)['read'].should be_a Array
    end
  end

  describe 'mark read user_reading' do
    parameter :auth_token,  "User's auth token"
    parameter :contents,    "Array of content IDs"
    parameter :id,          "Content ID"
    required_parameters :auth_token, :contents, :id
    scope_parameters :contents, [:id]

    post '/api/v1/contents/mark_read' do
      let(:auth_token)  { @user.auth_token }
      let(:contents)    { [{:id=>@content.id}] }
      let (:raw_post)   { params.to_json }  # JSON format request body
      
      example_request "[POST] Mark read user readings" do
        explanation "Mark specified contents as read for this user"

        status.should == 200
        JSON.parse(response_body).should_not be_empty
      end
    end

    post '/api/v1/contents/mark_read' do
      let(:auth_token)  { @user.auth_token }
      let(:contents)    { [{:id=>1234}] }
      let (:raw_post)   { params.to_json }  # JSON format request body
      
      example_request "[POST] Mark read user readings (404)" do
        explanation "Mark specified contents as read for this user"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

  post '/api/v1/contents/dismiss' do
    parameter :auth_token,  "User's auth token"
    parameter :contents,    "Array of content IDs"
    parameter :id,          "Content ID"
    required_parameters :auth_token, :contents, :id
    scope_parameters :contents, [:id]

    let(:auth_token)  { @user.auth_token }
    let(:contents)    { [{:id=>@content.id}] }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "[POST] Dismiss user readings" do
      explanation "Dismiss specified contents for this user"

      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  post '/api/v1/contents/save' do
    parameter :auth_token,  "User's auth token"
    parameter :contents,    "Array of content IDs"
    parameter :id,          "Content ID"
    required_parameters :auth_token, :contents, :id
    scope_parameters :contents, [:id]

    let(:auth_token)  { @user.auth_token }
    let(:contents)    { [{:id=>@content.id}] }
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

    example_request "[POST] Reset user readings (FOR TESTING ONLY)" do
      explanation "Clears the user's readings list"
      
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
