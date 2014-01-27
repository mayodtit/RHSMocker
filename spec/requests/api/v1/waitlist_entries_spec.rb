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

