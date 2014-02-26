require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Conditions' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:condition) { create(:condition) }

  get '/api/v1/conditions' do
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

      example_request "[GET] Search Conditions with query string" do
        explanation "Returns an array of Conditions retrieved by Solr"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        body[:conditions].map{|d| d[:id]}.should include(condition.id)
      end
    end
  end
end
