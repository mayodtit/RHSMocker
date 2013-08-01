require 'spec_helper'

describe 'Encounters' do
  describe 'index and show' do
    let!(:encounter) { create(:encounter) }
    let(:user) { encounter.users.first }

    before(:each) do
      user.login
    end

    describe 'GET /api/v1/encounters' do
      def do_request
        get "/api/v1/encounters", auth_token: user.auth_token
      end

      let!(:other_encounter) { create(:encounter) }

      it 'indexes the user\'s encounters' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        ids = body[:encounters].map{|e| e[:id]}
        ids.should include(encounter.id)
        ids.should_not include(other_encounter.id)
      end
    end

    describe 'GET /api/v1/encounters/:id' do
      def do_request
        get "/api/v1/encounters/#{encounter.id}", auth_token: user.auth_token
      end

      it 'shows a single encounter' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:encounter][:id].should == encounter.id
      end
    end
  end

  describe 'POST /api/v1/encounters' do
    let!(:user) { create(:member) }

    before(:each) do
      user.login
    end

    def do_request(params={})
      post "api/v1/encounters", params.merge!(auth_token: user.auth_token)
    end

    it 'creates a new encounter for the current user' do
      lambda{ do_request }.should change(Encounter, :count).by(1)
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      body[:encounter][:id].should_not be_nil
      user.reload.encounters.should include(Encounter.find(body[:encounter][:id]))
    end
  end
end
