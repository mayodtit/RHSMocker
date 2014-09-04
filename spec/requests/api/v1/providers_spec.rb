require 'spec_helper'

describe 'Providers' do
  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:provider) {
                   {
                     first_name: 'Kyle',
                     last_name: 'Chilcutt',
                     npi_number: '0123456789',
                     city: 'San Francisco',
                     state: 'CA',
                     expertise: 'Counterfeiting Medical Credentials'
                   }
                 }

  before do
    Search::Service.any_instance.stub(query: [provider])
  end

  describe 'GET /api/v1/providers' do
    def do_request
      get '/api/v1/providers', auth_token: session.auth_token
    end

    it 'indexes the providers' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:users].to_json).to eq([provider].as_json.to_json)
    end
  end
end
