require 'spec_helper'

describe Api::V1::SymptomsController do
  let!(:symptom) { build_stubbed(:symptom) }

  before do
    Symptom.stub(order: [symptom])
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'success'
    it 'returns an array of symptoms' do
      do_request
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:symptoms].to_json).to eq([symptom].serializer.as_json.to_json)
    end
  end
end
