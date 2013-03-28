require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "PhoneCalls" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login

    @message = FactoryGirl.create(:message, :user=>@user)
  end

  post '/api/v1/phone_calls' do
    parameter :auth_token,    "User's auth token"
    parameter :phone_call,    "Contains details of the phone call"
    parameter :message_id,    "ID of the message the call is referring to"
    parameter :time_to_call,  "One of (morning, afternoon, evening)"
    parameter :time_zone,     "Time zone specified as a number"

    scope_parameters :phone_call, [:message_id, :time_to_call, :time_zone]
    required_parameters :auth_token, :phone_call, :message_id, :time_to_call, :time_zone

    let(:auth_token)  { @user.auth_token }
    let(:message_id)  { @message.id }
    let(:time_to_call){ 'morning' }
    let(:time_zone)   { '-5' }
    let(:raw_post)    { params.to_json }  # JSON format request body

    example_request "[POST] Create (schedule) a phone call" do
      explanation "Returns the created phone call"
      status.should == 200
      JSON.parse(response_body)['phone_call'].should be_a Hash
    end
  end

end
