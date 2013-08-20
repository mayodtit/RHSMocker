require 'spec_helper'

describe 'Consults' do
  describe 'index and show' do
    let!(:consult) { create(:consult) }
    let(:user) { consult.users.first }

    before(:each) do
      user.login
    end

    describe 'GET /api/v1/consults' do
      def do_request
        get "/api/v1/consults", auth_token: user.auth_token
      end

      let!(:other_consult) { create(:consult) }

      it 'indexes the user\'s consults' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        ids = body[:consults].map{|e| e[:id]}
        ids.should include(consult.id)
        ids.should_not include(other_consult.id)
      end
    end

    describe 'GET /api/v1/consults/:id' do
      def do_request
        get "/api/v1/consults/#{consult.id}", auth_token: user.auth_token
      end

      it 'shows a single consult' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:consult][:id].should == consult.id
      end
    end
  end

  describe 'POST /api/v1/consults' do
    def do_request(params={})
      post "api/v1/consults", {auth_token: user.auth_token}.merge!(:consult => params)
    end

    let!(:user) { create(:member) }

    before(:each) do
      user.login
    end

    it 'creates a new consult for the current user as the subject' do
      lambda{ do_request }.should change(Consult, :count).by(1)
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      consult = Consult.find(body[:consult][:id])
      user.reload.consults.should include(consult)
      consult.initiator.should == user
      consult.subject.should == user
    end

    context 'with a subject' do
      let(:subject) { create(:user) }
      let(:subject_param) { {:subject_id => subject.id} }

      it 'creates a new consult for the given subject' do
        lambda{ do_request(subject_param) }.should change(Consult, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        consult = Consult.find(body[:consult][:id])
        user.reload.consults.should include(consult)
        consult.initiator.should == user
        consult.subject.should == subject
      end
    end

    context 'with a message' do
      let(:message_param) { {:message => {:text => 'test message'}} }

      it 'creates an consult for the current user' do
        lambda{ do_request(message_param) }.should change(Consult, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:consult][:id].should_not be_nil
        user.reload.consults.should include(Consult.find(body[:consult][:id]))
      end

      it 'creates a message for the user and consult' do
        lambda{ do_request(message_param) }.should change(Message, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        user.reload.messages.count.should == 1
        consult = Consult.find(body[:consult][:id])
        consult.messages.count.should == 1
        user.messages.first.should == consult.messages.first
      end
    end
  end
end
