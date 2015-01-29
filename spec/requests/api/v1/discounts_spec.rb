require 'spec_helper'

describe 'discounts' do
  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let (:discount) { create(:discount, member: user)}

  describe 'GET    /api/v1/users/:user_id/discounts' do
    def do_request(params = {})
      get '/api/v1/diseases', params.merge!(auth_token: session.auth_token)
    end

    it 'should return the discounts of of the user' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect( body[:discount].to_json ).to eq( discount.serializer.as_json.to_json )
    end
  end
end