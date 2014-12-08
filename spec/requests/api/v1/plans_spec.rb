require 'spec_helper'

describe 'Plans' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }
  describe 'GET /api/v1/plans' do
    def do_request
      get '/api/v1/plans', auth_token: session.auth_token
    end

    it 'return plans with text header' do
      do_request
      byebug
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:text_header]).to eq('Please select the plan below:')
    end

    it_behaves_like 'success'
    # it 'returns all the plans' do
    #   do_request
    #   expect(response).to be_success
    #   body = JSON.parse(response.body, symbolize_names: true)
    #   expect(body[:plans].to_json).to eq([plan].serializer.as_json.to_json)
    # end
  end
end
