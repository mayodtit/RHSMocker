require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Allergies" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:allergy) { create(:allergy) }

  get '/api/v1/allergies' do
    parameter :q, "Query string"
    required_parameters :q

    let(:q)   { allergy.name }

    example_request "[GET] Search allergies with query string" do
      explanation "Returns an array of allergies retrieved by Solr"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

   get '/api/v1/allergies' do
    example_request "[GET] Get all allergies" do
      explanation "Returns an array of allergies"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end
