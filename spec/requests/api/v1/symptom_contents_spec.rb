require 'spec_helper'

describe 'SymptomContents' do
  let!(:factor_content) { create(:factor_content) }
  let(:factor) { factor_content.factor }
  let(:symptom) { factor.symptom }
  let(:content) { factor_content.content }

  describe 'GET /api/v1/symptoms/:symptom_id/contents' do
    def do_request(params={})
      get "/api/v1/symptoms/#{symptom.id}/contents", params
    end

    it 'indexes the symptom contents' do
      do_request
      expect(response).to be_success
      json = JSON.parse(response.body, symbolize_names: true)
      json[:contents].to_json.should == [content].as_json.to_json
    end

    context 'with factor filters' do
      let!(:other_factor) { create(:factor, factor_group: factor.factor_group) }
      let!(:other_factor_content) { create(:factor_content, factor: other_factor) }
      let(:other_content) { other_factor_content.content }

      it 'indexes filtered symptom contents' do
        do_request(factor_ids: [factor.id])
        expect(response).to be_success
        json = JSON.parse(response.body, symbolize_names: true)
        content_ids = json[:contents].map{|c| c[:id]}
        expect(content_ids).to include(content.id)
        expect(content_ids).to_not include(other_content.id)
      end
    end
  end
end
