require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Consults" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }

  before(:each) do
    user.login
  end

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  describe 'index and show' do
    let!(:consult) { create(:consult, :with_messages, :users => [user]) }

    get '/api/v1/consults' do
      example_request "[GET] Get all consults for a given user" do
        explanation "Returns an array of consults"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:consults]
        body.should be_a Array
        body.should_not be_empty
      end
    end

    get '/api/v1/consults/:id' do
      let(:id) { consult.id }

      example_request "[GET] Get a consult for a given user" do
        explanation "Returns a single consult"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:consult]
        body.should be_a Hash
        body[:id].should == consult.id
      end
    end
  end

  post '/api/v1/consults' do
    let!(:content) { create(:content) }
    let!(:mayo_vocabulary) { create(:mayo_vocabulary) }
    let(:consult) { attributes_for(:consult, :users => nil).keep_if{|k,v| v.present?} }

    parameter :consult, 'Hash of consult parameters'

    context 'with a message' do
      let(:message) { attributes_for(:message, :content_id => content.id,
                                               :new_location => attributes_for(:location),
                                               :new_keyword_ids => [mayo_vocabulary.id]) }
      let(:consult_image) { base64_test_image }

      parameter :message, 'Hash of message parameters'
      parameter :consult_image, 'Base64 encoded image'

      scope_parameters :consult, [:message, :consult_image]

      let(:raw_post) { params.to_json }

      example_request "[POST] Create a Consult with a Message" do
        explanation "Creates a new Consult for a given user"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:consult]
        body.should be_a Hash
        body[:image_url].should_not be_nil
      end
    end

    context 'with a phone_call' do
      let(:phone_call) { attributes_for(:phone_call) }

      parameter :phone_call, 'Hash of phone_call parameters'

      scope_parameters :consult, [:phone_call]

      let(:raw_post) { params.to_json }

      example_request "[POST] Create a Consult with a PhoneCall" do
        explanation "Creates a new Consult for a given user"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:consult]
        body.should be_a Hash
      end
    end

    context 'with a scheduled_phone_call' do
      let(:scheduled_phone_call) { attributes_for(:scheduled_phone_call) }

      parameter :phone_call, 'Hash of scheduled_phone_call parameters'

      scope_parameters :consult, [:phone_call]

      let(:raw_post) { params.to_json }

      example_request "[POST] Create a Consult with a ScheduledPhoneCall" do
        explanation "Creates a new Consult for a given user"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:consult]
        body.should be_a Hash
      end
    end
  end
end
