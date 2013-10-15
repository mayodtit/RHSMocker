require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Encounters" do
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
    let!(:encounter) { create(:encounter, :users => [user]) }

    get '/api/v1/encounters' do
      example_request "[DEPRECATED] [GET] Get all encounters for a given user" do
        explanation "Returns an array of encounters"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:encounters]
        body.should be_a Array
        body.should_not be_empty
      end
    end

    get '/api/v1/encounters/:id' do
      let(:id) { encounter.id }

      example_request "[DEPRECATED] [GET] Get an encounter for a given user" do
        explanation "Returns an array of encounters"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:encounter]
        body.should be_a Hash
        body[:id].should == encounter.id
      end
    end
  end

  post '/api/v1/encounters' do
    let!(:content) { create(:content) }
    let!(:mayo_vocabulary) { create(:mayo_vocabulary) }
    let(:encounter) { attributes_for(:encounter, :users => nil).keep_if{|k,v| v.present?} }
    let(:message) { attributes_for(:message, :content_id => content.id,
                                             :new_location => attributes_for(:location),
                                             :new_keyword_ids => [mayo_vocabulary.id]) }

    parameter :encounter, 'Hash of encounter parameters'
    parameter :message, 'Hash of message parameters'

    scope_parameters :encounter, [:message]

    let(:raw_post) { params.to_json }

    example_request "[DEPRECATED] [POST] Create an Encounter" do
      explanation "Creates a new Encounter for a given user"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)[:encounter]
      body.should be_a Hash
    end
  end
end
