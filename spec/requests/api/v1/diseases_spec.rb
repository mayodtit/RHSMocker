require 'spec_helper'

describe 'Diseases' do
  let!(:disease) { create(:disease) }

  describe 'GET /api/v1/diseases' do
    def do_request(params=nil)
      get '/api/v1/diseases', params
    end

    it 'indexes all Diseases' do
      do_request
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      ids = body[:diseases].map{|c| c[:id]}
      ids.should include(disease.id)
    end

    context 'with a query param' do
      before(:each) do
        Condition.stub_chain(:search, :results).and_return([disease])
      end

      it 'filters Diseases with SOLR' do
        do_request(:q => disease.name)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        ids = body[:diseases].map{|c| c[:id]}
        ids.should include(disease.id)
      end
    end
  end
end
