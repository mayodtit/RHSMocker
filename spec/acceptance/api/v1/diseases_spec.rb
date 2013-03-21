require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Diseases" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @disease = FactoryGirl.create(:disease, :name=>"scurvy")
    @disease2 = FactoryGirl.create(:disease, :name=>"scurvy2")
  end

 

  get '/api/v1/diseases' do
    parameter :q, "Query string"
    required_parameters :q

    let(:q)   { @disease.name }

    example_request "[GET] Search diseases with query string" do
      explanation "Returns an array of diseases retrieved by Solr"

      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end