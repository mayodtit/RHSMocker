require 'spec_helper'

describe 'UserRequests' do
  let(:user) { create(:member) }

  describe 'POST /api/v1/users/:user_id/appointment_requests' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/appointment_requests", params.merge!(auth_token: user.auth_token)
    end

    let!(:user_request_type) { create(:appointment_user_request_type) }
    let(:user_request_attributes) { {name: 'new user request', subject_id: user.id} }

    it 'creates a user_request' do
      expect{ do_request(user_request: user_request_attributes) }.to change(UserRequest, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:user_request][:name]).to eq(user_request_attributes[:name])
    end
  end
end
