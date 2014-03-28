require 'spec_helper'

describe 'Plans' do
  let!(:user) { create(:member) }
  let!(:plan) { create(:plan) }

  describe 'GET /api/v1/plans' do
    def do_request
      get '/api/v1/plans', auth_token: user.auth_token
    end

    it 'returns all the plans' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:plans].to_json).to eq([plan].serializer.as_json.to_json)
    end
  end
end
