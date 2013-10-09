require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Messages" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }
  let!(:consult) { create(:consult, :with_messages, :users => [user]) }
  let(:consult_id) { consult.id }

  before(:each) do
    user.login
  end

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  get '/api/v1/consults/:consult_id/messages' do
    example_request "[GET] Get all Messages for a given Consult" do
      explanation "Returns an array of Messages"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)[:messages]
      body.should be_a Array
      body.should_not be_empty
    end
  end

  get '/api/v1/consults/:consult_id/messages/:id' do
    let(:message) { create(:message, :consult => consult) }
    let(:id) { message.id }

    example_request "[GET] Get a Message for a given Consult" do
      explanation "Returns a Message hash"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)[:message]
      body.should be_a Hash
      body[:id].should == message.id
    end
  end

  post '/api/v1/consults/:consult_id/messages' do
    let!(:content) { create(:content) }
    let!(:mayo_vocabulary) { create(:mayo_vocabulary) }
    let(:message) { attributes_for(:message, :content_id => content.id,
                                             :new_location => attributes_for(:location),
                                             :new_keyword_ids => [mayo_vocabulary.id],
                                             :new_attachments => [attributes_for(:attachment)]) }
    let(:image) { base64_test_image }

    parameter :message, 'Hash of message parameters'
    parameter :image, 'Base64 encoded image'
    scope_parameters :message, [:image]

    let(:raw_post) { params.to_json }

    example_request "[POST] Create a new Message for a given Consult" do
      explanation "Creates a new Message for a given Consult from the current user"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)[:message]
      body.should be_a Hash
      body[:image_url].should_not be_nil
    end
  end
end
