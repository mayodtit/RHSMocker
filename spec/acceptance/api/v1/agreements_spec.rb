require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Agreements" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:user_with_email).tap{|u| u.login} }
  let!(:ap) { create(:agreement_page, :page_type => :user_agreement) }
  let!(:ap1) { create(:agreement_page, :page_type => :user_agreement) }
  let!(:ap2) { create(:agreement_page, :page_type => :privacy_policy) }
  let!(:ap3) { create(:agreement_page, :page_type => :privacy_policy) }

  before(:each) do
    user.agreement_pages << ap1
    user.agreement_pages << ap2
  end

  get '/api/v1/agreements' do
    parameter :auth_token,    "User's auth token"
    required_parameters :auth_token

    let(:auth_token) { user.auth_token }

    example_request "[GET] Get all latest agreements for user" do
      explanation "Returns an array of latest agreements (one of each)"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  get '/api/v1/agreements/up_to_date' do
    parameter :auth_token,    "User's auth token"
    required_parameters :auth_token

    let(:auth_token) { user.auth_token }

    example_request "[GET] Check that the user agreed to all the latest agreement pages" do
      explanation "Check that the user agreed to all the latest agreement pages"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  describe 'accept agreement' do
    parameter :auth_token,      "User's auth token"
    parameter :agreement_page,  "Agreement page object"
    parameter :id,              "ID of agreement page"
    scope_parameters :agreement_page, [:id]
    required_parameters :auth_token, :agreement_page, :id

    post '/api/v1/agreements' do
      let(:auth_token)  { user.auth_token }
      let(:id)          { ap.id }
      let(:raw_post)    { params.to_json }  # JSON format request body

      example_request "[POST] Accept an agreement" do
        explanation "User accepts an agreement"
        status.should == 200
        JSON.parse(response_body).should_not be_empty
      end
    end

    post '/api/v1/agreements' do
      let(:auth_token)  { user.auth_token }
      let(:raw_post)    { params.to_json }  # JSON format request body

      example_request "[POST] Accept an agreement b (412)" do
        explanation "User accepts an agreement"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post '/api/v1/agreements' do
      let(:auth_token)  { user.auth_token }
      let(:id)          { nil }
      let(:raw_post)    { params.to_json }  # JSON format request body

      example_request "[POST] Accept an agreement c (412)" do
        explanation "User accepts an agreement"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post '/api/v1/agreements' do
      let(:auth_token)  { user.auth_token }
      let(:id)          { 1234 }
      let(:raw_post)    { params.to_json }  # JSON format request body

      example_request "[POST] Accept an agreement d (404)" do
        explanation "User accepts an agreement"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

end
