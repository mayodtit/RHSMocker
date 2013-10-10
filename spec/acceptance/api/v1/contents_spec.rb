require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Contents" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:user_with_email).tap{|u| u.login} }
  let!(:content) { create(:disease_content) }

  get '/api/v1/contents' do
    parameter :auth_token, "User's auth_token"
    required_parameters :auth_token

    let(:auth_token)  { user.auth_token}

    example_request "[GET] Get all contents (should not be used in the iOS app)" do
      explanation "Returns all the contents in the database ordered by their title"
      status.should == 200
      response = JSON.parse response_body
      response['contents'].should be_a Array
      content = response['contents'].first
      content.keys.should include('title', 'contents_type', 'contentID')
    end
  end

  get '/api/v1/contents' do
    parameter :auth_token, "User's auth_token"
    parameter :q, "Query string"
    required_parameters :auth_token, :q

    let(:auth_token)  { user.auth_token}
    let(:q)   { 'craniosynostosis' }

    example_request "[GET] Search contents with query string" do
      explanation "Returns an array of contents retrieved by Solr"
      status.should == 200
      JSON.parse(response_body)['contents'].should_not be_nil
    end
  end

  get '/api/v1/contents/:id' do
    parameter :auth_token, "User's auth_token"
    parameter :id,  "Content ID"
    required_parameters :auth_token, :id

    let(:auth_token)  { user.auth_token}
    let(:id)       { content.id }

    example_request "[GET] Get specific content" do
      explanation "Returns the specified content with its HTML formatted body"
      status.should == 200
      content = JSON.parse response_body
      content.should include('content')
    end
  end

  get '/api/v1/contents/:id' do
    parameter :auth_token, "User's auth_token"
    parameter :id,  "Content ID"
    parameter :q, "Query string"
    required_parameters :auth_token, :id, :q

    let(:auth_token)  { user.auth_token }
    let(:id)       { content.id }
    let(:q)   { 'cardview' }

    example_request "[GET] Get specific content (cardview)" do
      explanation "Returns the specified content with its HTML formatted body for cardview"
      status.should == 200
      content = JSON.parse response_body
      content.should include('content')
    end
  end

  get '/api/v1/contents/:id' do
    parameter :auth_token, "User's auth_token"
    parameter :id,  "Content ID"
    required_parameters :auth_token, :id

    let(:auth_token)  { user.auth_token}
    let(:id)       { 1234 }

    example_request "[GET] Get specific content (404)" do
      explanation "Returns the specified content with its HTML formatted body"
      status.should == 404
      JSON.parse(response_body)['reason'].should_not be_empty
    end
  end

  post '/api/v1/contents/:id/like' do
    parameter :auth_token, "User's auth_token"
    parameter :id,         'Content ID'
    required_parameters :auth_token, :id

    let(:auth_token) { user.auth_token }
    let(:id)         { content.id }
    let(:raw_post)   { params.to_json }

    example_request '[POST] Like specific content' do
      explanation "Like specific content for the current_user"
      status.should == 200
    end
  end

  post '/api/v1/contents/:id/dislike' do
    parameter :auth_token, "User's auth_token"
    parameter :id,         'Content ID'
    required_parameters :auth_token, :id

    let(:auth_token) { user.auth_token }
    let(:id)         { content.id }
    let(:raw_post)   { params.to_json }

    example_request '[POST] Dislike specific content' do
      explanation "Dislike specific content for the current_user"
      status.should == 200
    end
  end

  post '/api/v1/contents/:id/remove_like' do
    parameter :auth_token, "User's auth_token"
    parameter :id,         'Content ID'
    required_parameters :auth_token, :id

    let(:auth_token) { user.auth_token }
    let(:id)         { content.id }
    let(:raw_post)   { params.to_json }

    example_request '[POST] Remove a specific content like or dislike' do
      explanation "Remove specific content like or dislike for the current_user"
      status.should == 200
    end
  end
end
