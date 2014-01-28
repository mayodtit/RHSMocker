require 'spec_helper'

describe 'WaitlistEntry' do
  let(:admin) { create(:admin) }

  context 'existing record' do
    let!(:waitlist_entry) { create(:waitlist_entry) }

    describe 'GET /api/v1/waitlist_entries' do
      def do_request
        get '/api/v1/waitlist_entries', auth_token: admin.auth_token
      end

      it 'indexes all waitlist_entries' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:waitlist_entries].to_json).to eq([waitlist_entry].as_json.to_json)
      end
    end

    describe 'PUT /api/v1/waitlist_entries/:id' do
      def do_request(params={})
        put "/api/v1/waitlist_entries/#{waitlist_entry.id}", params.merge!(auth_token: admin.auth_token)
      end

      it 'updates the waitlist_entry' do
        do_request(waitlist_entry: {state_event: :invite})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:waitlist_entry].to_json).to eq(waitlist_entry.reload.as_json.to_json)
        expect(waitlist_entry.state?(:invited)).to be_true
      end
    end

    describe 'DELETE /api/v1/waitlist_entries/:id' do
      def do_request(params={})
        delete "/api/v1/waitlist_entries/#{waitlist_entry.id}", auth_token: admin.auth_token
      end

      it 'revokes the waitlist_entry' do
        do_request
        expect(response).to be_success
        expect(waitlist_entry.reload.state?(:revoked)).to be_true
      end
    end
  end

  describe 'POST /api/v1/waitlist_entries' do
    context 'logged in' do
      def do_request(params={})
        post "/api/v1/waitlist_entries", auth_token: admin.auth_token
      end

      it 'creates a new waitlist_entry' do
        expect{ do_request }.to change(WaitlistEntry, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        new_record = WaitlistEntry.find(body[:waitlist_entry][:id])
        expect(new_record.creator).to eq(admin)
        expect(new_record.state?(:invited)).to be_true
      end
    end

    context 'not logged in' do
      def do_request(params={})
        post "/api/v1/waitlist_entries", params
      end

      let(:email) { 'email@test.getbetter.com' }
      let(:attributes) { {email: email} }

      it 'creates a new waitlist_entry' do
        expect{ do_request(:waitlist_entry => attributes) }.to change(WaitlistEntry, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:waitlist_entry][:email].to_json).to eq(attributes[:email].to_json)
      end
    end
  end
end

