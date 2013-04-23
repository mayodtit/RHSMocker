require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Allergies" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @allergy = FactoryGirl.create(:allergy, :name=>"dust")
  end


  get '/api/v1/allergies' do
    parameter :q, "Query string"
    required_parameters :q

    let(:q)   { @allergy.name }

    example_request "[GET] Search allergies with query string" do
      explanation "Returns an array of allergies retrieved by Solr"

      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
