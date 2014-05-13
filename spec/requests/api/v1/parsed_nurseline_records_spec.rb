require 'spec_helper'

describe 'ParsedNurselineRecords' do
  let!(:user) { create(:pha) }
  let!(:parsed_nurseline_record) { create(:parsed_nurseline_record) }

  describe 'GET /api/v1/parsed_nurseline_records/:id' do
    def do_request
      get "/api/v1/parsed_nurseline_records/#{parsed_nurseline_record.id}", auth_token: user.auth_token
    end

    it 'shows the ParsedNurselineRecord' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:parsed_nurseline_record].to_json).to eq(parsed_nurseline_record.as_json.to_json)
    end
  end
end
