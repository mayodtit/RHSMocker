require 'spec_helper'

describe Api::V1::SymptomContentsController do
  let!(:factor_content) { build_stubbed(:factor_content) }
  let!(:symptom) { factor_content.factor.factor_group.symptom }
  let!(:content) { factor_content.content }

  before do
    symptom.stub(id: 1)
    Symptom.stub(find: symptom)
    Content.stub_chain(:joins, :where).and_return([content])
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'success'

    it 'returns an array of contents for the symptom' do
      do_request
      json = JSON.parse(response.body, symbolize_names: true)
      content_ids = json[:contents].map{|c| c[:id]}
      expect(content_ids).to include(content.id)
    end
  end
end
