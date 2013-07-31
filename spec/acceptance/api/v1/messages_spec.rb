require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Messages" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    @user2 = FactoryGirl.create(:user_with_email)
    @user2.login

    @encounter = FactoryGirl.create(:encounter, :with_messages)
    FactoryGirl.create(:encounters_user, :user=>@user, :encounter=>@encounter)

    @attachment = FactoryGirl.create(:attachment)
    @location = FactoryGirl.create(:user_location)
    @patient_user = FactoryGirl.create(:user_with_email)
    @keyword = FactoryGirl.create(:mayo_vocabulary)

    @message1 = FactoryGirl.create(:message, :text=>'I have a rash', :user=>@user, :encounter=>@encounter)
    @message2 = FactoryGirl.create(:message, :text=>'Please send a picture', :user=>@user)

    @content = FactoryGirl.create(:disease_content)
  end


  get '/api/v1/messages' do
    parameter :auth_token,       "User's auth token"
    required_parameters :auth_token

    let(:auth_token)    { @user.auth_token }

    example_request "[GET] Get all of this user's encounters" do
      explanation "Returns an array of all encounters the user's involved in"
      status.should == 200
      JSON.parse(response_body)['encounters'].should be_a Array
    end
  end

  get '/api/v1/messages/:id' do
    parameter :auth_token,       "User's auth token"
    parameter :id,       "Message id"
    required_parameters :auth_token, :id

    let(:auth_token)    { @user.auth_token }
    let(:id)    { @message1.id }

    example_request "[GET] Get message by id" do
      explanation "Returns rendered message"
      status.should == 200
    end
  end

  get '/api/v1/messages/:id' do
    parameter :auth_token,       "User's auth token"
    parameter :id,       "Message id"
    required_parameters :auth_token, :id

    let(:auth_token)    { @user.auth_token }
    let(:id)            { 1234 }

    example_request "[GET] Get message by id (404)" do
      explanation "Returns rendered message"
      status.should == 404
      JSON.parse(response_body)['reason'].should_not be_empty
    end
  end

  get '/api/v1/messages/:id' do
    parameter :q,     "cardview"
    parameter :auth_token,       "User's auth token"
    parameter :id,       "Message id"
    required_parameters :q, :auth_token, :id

    let(:q) { "cardview"}
    let(:auth_token)    { @user.auth_token }
    let(:id)    { @message1.id }

    example_request "[GET] Get message by id (cardview)" do
      explanation "Returns rendered message in cardview"
      status.should == 200
    end
  end


  describe 'create message with a new encounter' do
    parameter :auth_token,      "User's auth token"
    parameter :keywords,        "Keywords to add to the message"
    parameter :text,            "The body text for the message"
    parameter :attachments,     "Set of urls to attachments (images)"
    parameter :url,             "Url of the attachment"
    parameter :location,        "Latitude and longitude of location where message was sent from"
    parameter :latitude,        "Latitude of the location"
    parameter :longitude,       "Longitude of the location"
    parameter :patient_user_id, "User id of the patient. If not specified, the current user is the patient"
    parameter :encounter,       "Encapsulating encounter object"
    parameter :priority,        "Priority of the encounter. Default: 'medium'"
    parameter :content_id,      "Content associated with the message"

    scope_parameters :encounter, [:priority]
    scope_parameters :location, [:latitude, :longitude]
    scope_parameters :attachments, [:url]
    required_parameters :auth_token, :text


    post "/api/v1/messages" do
      let(:auth_token)      { @user.auth_token }
      let(:keywords)        { [ @keyword.title ] }
      let(:text)            { "Ouch, my liver" }
      let(:attachments)     { [ @attachment ] }
      let(:location)        { @location }
      let(:patient_user_id) { @patient_user.id }
      let(:priority)        { "medium" }
      let(:content_id)      { @content.id }
      let(:raw_post)        { params.to_json }  # JSON format request body

      example_request "[POST] Create a message with a new encounter" do
        explanation "Endpoint for posting a new message. If the patient_user_id is not supplied, we assume that the current user is the patient."

        status.should == 200
        JSON.parse(response_body)['message'].should_not be_empty
        JSON.parse(response_body)['warnings'].should be_a Array
      end
    end

    post "/api/v1/messages" do
      let(:auth_token)      { @user.auth_token }
      let(:keywords)        { [ @keyword.title ] }
      let(:text)            { "Ouch, my liver" }
      let(:attachments)     { [ @attachment ] }
      let(:location)        { @location }
      let(:patient_user_id) { 1234 }
      let(:priority)        { "medium" }
      let(:content_id)      { @content.id }
      let(:raw_post)        { params.to_json }  # JSON format request body

      example_request "[POST] Create a message with a new encounter b (404)" do
        explanation "Endpoint for posting a new message. If the patient_user_id is not supplied, we assume that the current user is the patient."
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post "/api/v1/messages" do
      let(:auth_token)      { @user.auth_token }
      let(:keywords)        { [ @keyword.title ] }
      let(:text)            { "Ouch, my liver" }
      let(:attachments)     { [ @attachment ] }
      let(:location)        { @location }
      let(:patient_user_id) { @patient_user.id }
      let(:priority)        { "medium" }
      let(:content_id)      { 1234 }
      let(:raw_post)        { params.to_json }  # JSON format request body

      example_request "[POST] Create a message with a new encounter c (404)" do
        explanation "Endpoint for posting a new message. If the patient_user_id is not supplied, we assume that the current user is the patient."
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'create message to an existing encounter' do
    parameter :auth_token, "User's auth token"
    parameter :keywords, "Keywords to add to the message"
    parameter :text, "The body text for the message"
    parameter :attachments, "Set of urls to attachments (images)"
    parameter :url, "Url of the attachment"
    parameter :location, "Latitude and longitude of location where message was sent from"
    parameter :latitude, "Latitude of the location"
    parameter :longitude, "Longitude of the location"
    parameter :encounter, "Encapsulating encounter object"
    parameter :id, "Id of the encounter"

    scope_parameters :encounter, [:id]
    scope_parameters :location, [:latitude, :longitude]
    scope_parameters :attachments, [:url]
    required_parameters :auth_token, :text


    post "/api/v1/messages" do
      let(:auth_token) {@user.auth_token}
      let(:keywords) {[@keyword.title]}
      let(:text) {"Ouch, my liver"}
      let(:attachments){[@attachment]}
      let(:location){@location}
      let(:id){@encounter.id}
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[POST] Create a response message to an existing encounter" do
        explanation "Endpoint for posting a new message on an existing encounter"

        status.should == 200
        JSON.parse(response_body).should_not be_empty
      end
    end

    post "/api/v1/messages" do
      let(:auth_token)  {@user.auth_token}
      let(:keywords)    {[@keyword.title]}
      let(:text)        {"Ouch, my liver"}
      let(:attachments) {[@attachment]}
      let(:location)    {@location}
      let(:id)          { 1234 }
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[POST] Create a response message to an existing encounter b (404)" do
        explanation "Endpoint for posting a new message on an existing encounter"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post "/api/v1/messages" do
      let(:auth_token)  {@user2.auth_token}
      let(:keywords)    {[@keyword.title]}
      let(:text)        {"Ouch, my liver"}
      let(:attachments) {[@attachment]}
      let(:location)    {@location}
      let(:id)          { @encounter.id }
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[POST] Create a response message to an existing encounter c (401)" do
        explanation "Endpoint for posting a new message on an existing encounter"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post "/api/v1/messages" do
      let(:auth_token) {@user.auth_token}
      let(:keywords) {[@keyword.title]}
      let(:text) {""}
      let(:attachments){[@attachment]}
      let(:location){@location}
      let(:id){@encounter.id}
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[POST] Create a response message to an existing encounter d (412)" do
        explanation "Endpoint for posting a new message on an existing encounter"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'mark message as read' do
    parameter :auth_token,  "User's auth token"
    parameter :messages,    "Collection of augmented message objects"
    parameter :id,          "Message ID"
    required_parameters :auth_token, :messages
    scope_parameters :message, [:id]


    post '/api/v1/messages/mark_read' do
      let(:auth_token)  { @user.auth_token }
      let(:messages)    { [{id:@message1.id}, {id:@message2.id}] }
      let(:raw_post)    { params.to_json }  # JSON format request body

      example_request "[POST] Mark message(s) as read" do
        explanation "Pass a set of augmented message objects (with ids) and have them marked at 'read'"

        status.should == 200
        JSON.parse(response_body)['warnings'].should be_a Array
      end
    end

    post '/api/v1/messages/mark_read' do
      let(:auth_token)  { @user.auth_token }
      let(:messages)    { }
      let(:raw_post)    { params.to_json }  # JSON format request body

      example_request "[POST] Mark message(s) as read (412)" do
        explanation "Pass a set of augmented message objects (with ids) and have them marked at 'read'"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'mark message as dimiss' do
    parameter :auth_token,  "User's auth token"
    parameter :messages,    "Collection of augmented message objects"
    parameter :id,          "Message ID"
    required_parameters :auth_token, :messages
    scope_parameters :message, [:id]


    post '/api/v1/messages/dismiss' do
      let(:auth_token)  { @user.auth_token }
      let(:messages)    { [{id:@message1.id}, {id:@message2.id}] }
      let(:raw_post)    { params.to_json }  # JSON format request body

      example_request "[POST] Mark message(s) as dismissed" do
        explanation "Pass a set of augmented message objects (with ids) and have them marked at 'dismissed'"

        status.should == 200
        JSON.parse(response_body)['warnings'].should be_a Array
      end
    end

    post '/api/v1/messages/dismiss' do
      let(:auth_token)  { @user.auth_token }
      let(:messages)    { }
      let(:raw_post)    { params.to_json }  # JSON format request body

      example_request "[POST] Mark message(s) as dismissed (412)" do
        explanation "Pass a set of augmented message objects (with ids) and have them marked at 'dismissed'"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

end
