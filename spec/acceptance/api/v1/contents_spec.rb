require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Contents" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    FactoryGirl.create(:content)
    @content = FactoryGirl.create(:disease_content)
    FactoryGirl.create(:disease_content)
  end

  get '/api/v1/contents' do
    example_request "[GET] Get all contents (should not be used in the iOS app)" do
      explanation "Returns all the contents in the database ordered by their title"

      status.should == 200
      response = JSON.parse response_body
      response['contents'].should be_a Array
      content = response['contents'].first
      content.should include('title', 'body', 'contentsType', 'abstract', 'question', 'keywords', 'updateDate')
    end
  end

  get '/api/v1/contents' do
    parameter :q, "Query string"
    required_parameters :q

    let(:q)   { 'craniosynostosis' }

    example_request "[GET] Search contents with query string" do
      explanation "Returns an array of contents retrieved by Solr"

      status.should == 200
      JSON.parse(response_body).should be_a Array
    end
  end

  get '/api/v1/contents/:id' do
    parameter :id,  "Content ID"
    required_parameters :id

    let(:id)       { @content.id }

    example_request "[GET] Get specific content" do
      explanation "Returns the specified content with its HTML formatted body"

      status.should == 200
      content = JSON.parse response_body
      content.should include('title', 'contents_type', 'contentID', 'body')
    end
  end

  get '/api/v1/contents/:id?q=cardview' do
    parameter :id,  "Content ID"
    required_parameters :id

    let(:id)       { @content.id }

    example_request "[GET] Get specific content (cardview)" do
      explanation "Returns the specified content with its HTML formatted body for cardview"

      status.should == 200
      content = JSON.parse response_body
      content.should include('title', 'contents_type', 'contentID', 'body')
    end
  end

  get '/api/v1/contents/:id' do
    parameter :id,  "Content ID"
    required_parameters :id

    let(:id)       { 1234 }

    example_request "[GET] Get specific content (404)" do
      explanation "Returns the specified content with its HTML formatted body"

      status.should == 404
      JSON.parse(response_body)['reason'].should_not be_empty
    end
  end

end
