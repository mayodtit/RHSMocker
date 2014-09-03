require 'spec_helper'

describe 'Ping' do
  describe 'POST /api/v1/ping' do
    def do_request
      post '/api/v1/ping', options
    end

    context 'with an auth_token' do
      def do_request(options={})
        post '/api/v1/ping', options.merge!(auth_token: session.auth_token)
      end

      let!(:user) { create(:member) }
      let(:session) { user.sessions.create }
      let(:apns_token) { 'test_token' }
      let(:gcm_id) { 'test_gcm_id' }

      it 'stores the apns token when present' do
        expect(session.apns_token).to be_nil
        do_request(device_token: apns_token)
        expect(session.reload.apns_token).to eq(apns_token)
      end

      it 'stores the GCM id when present' do
        expect(session.gcm_id).to be_nil
        do_request(android_gcm_id: gcm_id)
        expect(session.reload.gcm_id).to eq(gcm_id)
      end
    end
  end
end
