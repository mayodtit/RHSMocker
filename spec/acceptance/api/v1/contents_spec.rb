require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Contents" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @content = FactoryGirl.create(:content)
  end

  get '/api/v1/contents' do

    example_request "Getting all the contents" do
      explanation "Getting all the contents (should not be used in the iOS app)"

      resp = JSON.parse response_body

      status.should == 200
    end

  end

  get '/api/v1/contents' do
    parameter :q, "Query string"

    let (:q)   { "blood" }

    example_request "Searching contents" do
      explanation "Searching all the contents with the query string"

      resp = JSON.parse response_body

      status.should == 200
    end

  end

  get '/api/v1/contents/:id' do
    parameter :id,        "content id"

    let (:id)       { @content.id}
    example_request "Getting specific content" do
      explanation "Getting specific content (specified by id)"

      resp = JSON.parse response_body

      status.should == 200
    end

  end

  get '/api/v1/contents/:id?q=cardview' do
    parameter :id,        "content id"

    let (:id)       { @content.id}
    example_request "Getting specific content(cardview)" do
      explanation "Getting specific content (specified by id) in a cardview"

      resp = JSON.parse response_body

      status.should == 200
    end

  end


end
