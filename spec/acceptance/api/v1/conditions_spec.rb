require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Conditions" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @condition = FactoryGirl.create(:condition, :name=>"scurvy")
    @condition2 = FactoryGirl.create(:condition, :name=>"scurvy2")
  end

 

  get '/api/v1/conditions' do
    parameter :q, "Query string"
    required_parameters :q

    let(:q)   { @condition.name }

    example_request "[GET] Search conditions with query string" do
      explanation "Returns an array of conditions retrieved by Solr"

      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end
