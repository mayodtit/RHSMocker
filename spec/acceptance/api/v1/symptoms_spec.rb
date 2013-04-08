require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Symptoms" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before :all do
    FactoryGirl.create(:symptom)
    FactoryGirl.create(:symptom, :name=>'Cough')
  end

  get 'api/v1/symptoms' do
    example_request "[GET] Get all symptoms" do
      explanation "Returns an array of symptoms available, sorted by name"
      status.should == 200
      JSON.parse(response_body)['symptoms'].should be_a Array
    end
  end

end
