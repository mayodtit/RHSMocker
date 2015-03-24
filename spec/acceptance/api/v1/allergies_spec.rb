require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Allergies" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:allergy) { create(:allergy, 
      concept_id: "12345",
      description_id: "54321",
      environment_allergen: false,
      food_allergen: false,
      medication_allergen: true,
      name: "Penicillin",
      snomed_code: "835354015",
      snomed_name: "Allergy to penicillin (disorder)"
    ) }

  before(:each) do
    Allergy.stub_chain(:search, :results).and_return([allergy])
  end

  get '/api/v1/allergies' do
    parameter :q, "Query string"
    required_parameters :q

    let(:q)   { 'Peni' }

    example_request "[GET] Search allergies with query string" do
      explanation "Returns an array of allergies retrieved by Solr"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)
      expect(body[:allergies].to_json).to eq([allergy].as_json.to_json)
    end
  end

   get '/api/v1/allergies' do
    example_request "[GET] Get all allergies" do
      explanation "Returns an array of allergies"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)
      expect(body[:allergies].to_json).to eq([allergy].as_json.to_json)
    end
  end
end
