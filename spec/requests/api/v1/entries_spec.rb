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

  describe 'GET /api/v1/members/:member_id/entries?page=1&per=5' do
    let!(:first_entry) { create(:entry, member: member) }
    let!(:second_entry) { create(:entry, member: member) }
    let!(:third_entry) { create(:entry, member: member) }
    let!(:fourth_entry) { create(:entry, member: member) }
    let!(:fifth_entry) { create(:entry, member: member) }
    let!(:sixth_entry) { create(:entry, member: member) }

    def do_request
      get "/api/v1/members/#{member.id}/entries?page=1&per=5", auth_token: session.auth_token
    end

    it 'returns a paginated index of entries' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:entries].map {|i| i[:id]}).to include(second_entry.id, third_entry.id, fourth_entry.id, fifth_entry.id, sixth_entry.id)
      expect(body[:entries].size).to eql(5)
      expect(body[:total_count]).to eq(6)
    end
  end
end
