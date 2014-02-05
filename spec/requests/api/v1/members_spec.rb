require 'spec_helper'

shared_examples 'creates a member' do
  it 'creates a new member and returns member and auth_token' do
    expect{ do_request(member_params) }.to change(Member, :count).by(1)
    expect(response).to be_success
    body = JSON.parse(response.body, symbolize_names: true)
    member = Member.find(body[:user][:id])
    expect(body[:user].to_json).to eq(member.as_json.to_json)
    expect(body[:auth_token]).to eq(member.auth_token)
  end
end

describe 'Members' do
  context 'with existing record' do
    let!(:member) { create(:admin) }

    describe 'GET /api/v1/members' do
      def do_request(params={})
        get '/api/v1/members', {auth_token: member.auth_token}.merge!(params)
      end

      it 'indexes all Members' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, symbolize_names: true)
        ids = body[:users].map{|c| c[:id]}
        ids.should include(member.id)
      end

      context 'with a query param' do
        let!(:other_member) { create(:member) }

        it 'filters Members with param' do
          do_request(q: member.email)
          response.should be_success
          body = JSON.parse(response.body, symbolize_names: true)
          ids = body[:users].map{|c| c[:id]}
          ids.should include(member.id)
          ids.should_not include(other_member.id)
        end
      end
    end
  end

  describe 'POST /api/v1/members' do
    def do_request(params={})
      post '/api/v1/members', params
    end

    let(:member_params) { {user: attributes_for(:member)} }

    it_behaves_like 'creates a member'

    context 'with invite flow enabled' do
      before do
        Metadata.stub(use_invite_flow?: true)
      end

      context 'with an invite token' do
        let!(:waitlist_entry) { create(:waitlist_entry, :invited) }
        let(:member_params) { {user: (attributes_for(:member).merge!(token: waitlist_entry.token))} }

        it_behaves_like 'creates a member'

        it 'claims the invite token' do
          do_request(member_params)
          body = JSON.parse(response.body, symbolize_names: true)
          member = Member.find(body[:user][:id])
          expect(waitlist_entry.reload.state?(:claimed)).to be_true
          expect(waitlist_entry.claimer).to eq(member)
        end
      end
    end
  end
end
