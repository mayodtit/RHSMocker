require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Conditions' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  

  get '/api/v1/conditions' do
    let!(:condition) { create(:condition) }
    example_request '[GET] Get all Conditions' do
      explanation 'Returns an array of Conditions'
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)
      body[:conditions].map{|d| d[:id]}.should include(condition.id)
    end

    context 'with a query string' do
      before(:each) do
        Condition.stub_chain(:search, :results).and_return([condition])
      end

      parameter :q, "Query string"
      required_parameters :q
      let(:q) { condition.name.split(' ').first }

      example_request "[GET] Search Conditions with query string. [DEPRECATED]" do
        explanation "Returns an array of Conditions retrieved by Solr.  Please use api/v1/conditons/search instead"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        body[:conditions].map{|d| d[:id]}.should include(condition.id)
      end
    end
  end
  get '/api/v1/conditions/search' do
    let!(:condition) { create(:condition,
      name: "Influenza A (H1N1)",
      snomed_code: "442696006",
      snomed_name: "Influenza due to Influenza A virus subtype H1N1 (disorder)",
      concept_id: "442696006",
      description_id: "2820794017"
    ) }
    before(:each) do
        Condition.stub_chain(:search, :results).and_return([condition])
      end
    let(:q)   { 'H1' }

    example_request '[GET] Get all Conditions' do
      explanation 'Returns an array of Conditions'
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)
      body[:conditions].map{|d| d[:id]}.should include(condition.id)
    end
  end
end
