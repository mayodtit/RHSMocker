require 'spec_helper'

describe 'Ping' do
  describe 'POST /api/v1/ping' do
    def do_request
      post '/api/v1/ping', options
    end

    context 'with an auth_token' do
      def do_request(options={})
        post '/api/v1/ping', options.merge!(auth_token: user.auth_token)
      end

      let!(:user) { create(:member) }
      let(:apns_token) { 'test_token' }

      it 'stores the apns token when present' do
        expect(user.apns_token).to be_nil
        do_request(device_token: apns_token)
        expect(user.reload.apns_token).to eq(apns_token)
      end
    end
  end
end
