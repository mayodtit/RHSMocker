require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Treatments" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:medicine) { create(:medicine_treatment) }
  let!(:supplement) { create(:supplement_treatment) }
  let!(:vaccine) { create(:vaccine_treatment) }

  get '/api/v1/treatments' do
    parameter :q, "Query string"
    required_parameters :q

    let(:q) { medicine.name }

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
