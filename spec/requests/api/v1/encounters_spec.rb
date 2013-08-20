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
    def do_request(params={})
      post "api/v1/encounters", {auth_token: user.auth_token}.merge!(:encounter => params)
    end

    let!(:user) { create(:member) }

    before(:each) do
      user.login
    end

    it 'creates a new encounter for the current user as the subject' do
      lambda{ do_request }.should change(Encounter, :count).by(1)
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      encounter = Encounter.find(body[:encounter][:id])
      user.reload.encounters.should include(encounter)
      encounter.subject.should == user
    end

    context 'with a subject' do
      let(:subject) { create(:user) }
      let(:subject_param) { {:subject_id => subject.id} }

      it 'creates a new encounter for the given subject' do
        lambda{ do_request(subject_param) }.should change(Encounter, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        encounter = Encounter.find(body[:encounter][:id])
        user.reload.encounters.should include(encounter)
        encounter.subject.should == subject
      end
    end

    context 'with a message' do
      let(:message_param) { {:message => {:text => 'test message'}} }

      it 'creates an encounter for the current user' do
        lambda{ do_request(message_param) }.should change(Encounter, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:encounter][:id].should_not be_nil
        user.reload.encounters.should include(Encounter.find(body[:encounter][:id]))
      end

      it 'creates a message for the user and encounter' do
        lambda{ do_request(message_param) }.should change(Message, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        user.reload.messages.count.should == 1
        encounter = Encounter.find(body[:encounter][:id])
        encounter.messages.count.should == 1
        user.messages.first.should == encounter.messages.first
      end
    end
  end
end
