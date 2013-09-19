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
    parameter :type, "Treatment type"

    let(:type) { medicine.type_name }
    let(:q) { medicine.name.split(' ')[0] }

    example_request "[GET] Search treatments with query string and type" do
      explanation "Returns an array of treatments filtered by type matching query string"
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
