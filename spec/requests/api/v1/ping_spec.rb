require 'spec_helper'

describe 'Ping' do
  describe 'POST /api/v1/ping' do
    let!(:user) { create(:member) }
    let(:session) { user.sessions.create }
    let(:apns_token) { 'test_token' }
    let(:gcm_id) { 'test_gcm_id' }
    let(:device_os) {'test_device_os'}
    let(:device_timezone) {'ETC'}

    def do_request
      post '/api/v1/ping', options
    end

    context 'with an auth_token' do
      def do_request(options={})
        post '/api/v1/ping', options.merge!(auth_token: session.auth_token)
      end

      it 'indicates session is valid' do
        expect(session.apns_token).to be_nil
        do_request(device_token: apns_token)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:auth_token_valid]).to be_true
      end

      it 'stores the apns token when present' do
        expect(session.apns_token).to be_nil
        do_request(device_token: apns_token)
        expect(response).to be_success
        expect(session.reload.apns_token).to eq(apns_token)
      end

      it 'stores the GCM id when present' do
        expect(session.gcm_id).to be_nil
        do_request(android_gcm_id: gcm_id)
        expect(response).to be_success
        expect(session.reload.gcm_id).to eq(gcm_id)
      end

      context 'with NUX stories' do
        let!(:nux_story) { create(:nux_story, enabled: true) }

        it 'does not render stories when using exclude_stories' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:stories]).to_not be_empty

          do_request(exclude_stories: true)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:stories]).to be_nil
        end
      end
    end

    context 'with an invalid auth_token' do
      def do_request(options={})
        post '/api/v1/ping', options.merge!(auth_token: 'invalid_token')
      end

      it 'indicates session is not valid' do
        expect(session.apns_token).to be_nil
        do_request(device_token: apns_token)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:auth_token_valid]).to be_false
      end

      it 'not store the apns token when present' do
        expect(session.apns_token).to be_nil
        do_request(device_token: apns_token)
        expect(response).to be_success
        expect(session.reload.apns_token).to be_nil
      end

      it 'not store the GCM id when present' do
        expect(session.gcm_id).to be_nil
        do_request(android_gcm_id: gcm_id)
        expect(response).to be_success
        expect(session.reload.gcm_id).to be_nil
      end

      it 'not store the device os when present' do
        expect(session.device_os).to be_nil
        do_request(device_os: device_os)
        expect(response).to be_success
        expect(session.reload.gcm_id).to be_nil
      end

      it 'not store the user information when present' do
        expect(session.device_timezone).to be_nil
        do_request(device_timezone: device_timezone)
        expect(response).to be_success
        expect(session.reload.device_timezone).to be_nil
      end
    end
  end
end
