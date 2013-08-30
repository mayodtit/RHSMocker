require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Diseases' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:disease) { create(:disease) }

  get '/api/v1/diseases' do
    example_request '[DEPRECATED] [GET] Get all Diseases' do
      explanation 'Returns an array of Diseases'
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)
      body[:diseases].map{|d| d[:id]}.should include(disease.id)
    end

    context 'with a query string' do
      before(:each) do
        Condition.stub(:search => [disease])
      end

      parameter :q, "Query string"
      required_parameters :q
      let(:q) { disease.name.split(' ').first }

      example_request "[DEPRECATED] [GET] Search Diseases with query string" do
        explanation "Returns an array of Diseases retrieved by Solr"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        body[:diseases].map{|d| d[:id]}.should include(disease.id)
      end
    end
  end
end
