require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Treatments" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @treatment = FactoryGirl.create(:treatment)
    
    FactoryGirl.create(:treatment)
    FactoryGirl.create(:treatment)
  end


  get '/api/v1/treatments' do
    parameter :q,         "Query string"
    required_parameters :q

    let(:q)   { @treatment.name }

    example_request "[GET] Search treatments with query string" do
      explanation "Returns an array of treatments retrieved by Solr, if any."
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  get '/api/v1/treatments' do
    example_request "[GET] Get all treatments" do
      explanation "Returns an array of treatments"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
