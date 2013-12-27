require 'spec_helper'

describe 'Consults' do
  let!(:factor_group) { create(:factor_group) }
  let(:symptom) { factor_group.symptom }

  describe 'GET /api/v1/symptoms/:symptom_id/factor_groups' do
    def do_request
      get "/api/v1/symptoms/#{symptom.id}/factor_groups"
    end

    it 'indexes the symptom factor_groups' do
      do_request
      expect(response).to be_success
      json = JSON.parse(response.body, symbolize_names: true)
      json[:factor_groups].to_json.should == [factor_group].serializer.to_json
    end
  end
end
