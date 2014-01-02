require 'spec_helper'

describe Api::V1::FactorGroupsController do
  let!(:factor_group) { build_stubbed(:factor_group) }
  let(:symptom) { factor_group.symptom }

  before do
    Symptom.stub(find: symptom)
    symptom.stub_chain(:factor_groups, :order).and_return([factor_group])
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'success'
    it 'returns an array of factor_groups' do
      do_request
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:factor_groups].to_json).to eq([factor_group].serializer.as_json.to_json)
    end
  end
end
