require 'spec_helper'

describe 'Contents' do
  let(:user) { create(:member) }
  let(:session) { user.sessions.create }

  describe 'GET /api/v1/contents/tos' do
    def do_request
      get '/api/v1/contents/tos', auth_token: session.auth_token
    end

    let!(:tos) { MayoContent.terms_of_service || create(:mayo_content, :tos) }

    it 'shows the MayoContent.terms_of_service' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      expect(body[:content].to_json).to eq(tos.serializer.as_json.to_json)
    end
  end
end
