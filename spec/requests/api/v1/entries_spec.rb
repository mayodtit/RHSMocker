require 'spec_helper'

describe 'Entries' do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  let(:member) { create :member }
  let(:pha) { create :pha }
  let(:session) { pha.sessions.create }

  context 'existing record' do
    let!(:entry) { create(:entry, member: member) }

    describe 'GET /api/v1/members/:member_id/entries' do
      def do_request
        get "/api/v1/members/#{member.id}/entries", auth_token: session.auth_token
      end

      it "indexes member's entries" do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:entries].to_json).to eq([entry].serializer.as_json.to_json)
      end
    end
  end
end
