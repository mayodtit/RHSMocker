require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Messages" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:each) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login

    encounter = FactoryGirl.create(:encounter_with_messages)
    FactoryGirl.create(:encounters_user, :user=>@user, :encounter=>encounter)
    @attachment = FactoryGirl.create(:attachment)
    @location = FactoryGirl.create(:user_location)
    @patient_user = FactoryGirl.create(:user_with_email)
    @keyword = FactoryGirl.create(:mayo_vocabulary)
    @message = FactoryGirl.create(:message)
  end

  get '/api/v1/messages' do
    parameter :auth_token,       "User's auth token"
    required_parameters :auth_token

    let (:auth_token)    { @user.auth_token }

    example_request "[GET] Get all of this user's encounters" do
      explanation "Returns an array of all encounters the user's involved in"
      status.should == 200
      JSON.parse(response_body)['encounters'].should be_a Array
    end
  end

  post "/api/v1/messages" do
    parameter :auth_token, "User's auth token"
    parameter :keywords, "Keywords to add to the message"
    parameter :text, "The body text for the message"
    parameter :attachments, "Set of urls to attachments (images)"
    parameter :url, "Url of the attachment"
    parameter :location, "Latitude and longitude of location where message was sent from"
    parameter :latitude, "Latitude of the location"
    parameter :longitude, "Longitude of the location"
    parameter :patient_user_id, "User id of the patient. If not specified, the current user is the patient"
    parameter :encounter, "Encapsulating encounter object"
    parameter :priority, "Priority of the encounter. Default: 'medium'"
    scope_parameters :encounter, [:priority]
    scope_parameters :location, [:latitude, :longitude]
    scope_parameters :attachments, [:url]

    let(:auth_token) {@user.auth_token}
    let(:keywords) {[@keyword.title]}
    let(:text) {"Ouch, my liver"}
    let(:attachments){[@attachment]}
    let(:location){@location}
    let(:patient_user_id){@patient_user.id}
    let(:priority){"medium"}
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "[POST] Create a message with a new encounter" do
      explanation "Endpoint for posting a new message. If the patient_user_id is not supplied, we assume that the current user is the patient."

      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end

  end

  post '/api/v1/messages/mark_read' do
    parameter :auth_token,  "User's auth token"
    parameter :messages,    "Array of messages"
    required_parameters :auth_token, :messages

    let(:auth_token)  { @user.auth_token }
    let(:messages)    { [@message] }
    let(:raw_post)    { params.to_json }  # JSON format request body

    example_request "[POST] Mark message(s) as read" do
      explanation "Returns an array of warnings, if any."
      status.should == 200
      JSON.parse(response_body)['warnings'].should be_a Array
    end
  end

end
