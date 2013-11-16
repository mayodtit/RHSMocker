require 'spec_helper'

describe 'Members' do
  let!(:member) { create(:member) }

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
