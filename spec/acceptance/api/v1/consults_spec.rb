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
    let!(:consult) { create(:consult, :users => [user]) }

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

      example_request "[GET] Get an consult for a given user" do
        explanation "Returns an array of consults"
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
    let(:message) { attributes_for(:message, :content_id => content.id,
                                             :new_location => attributes_for(:location),
                                             :new_keyword_ids => [mayo_vocabulary.id],
                                             :new_attachments => [attributes_for(:attachment)]) }

    parameter :consult, 'Hash of consult parameters'
    parameter :message, 'Hash of message parameters'

    scope_parameters :consult, [:message]

    let(:raw_post) { params.to_json }

    example_request "[POST] Create an Consult" do
      explanation "Creates a new Consult for a given user"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)[:consult]
      body.should be_a Hash
    end
  end
end
