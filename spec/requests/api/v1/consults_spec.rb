require 'spec_helper'

shared_examples 'creates a consult' do
  it 'creates a consult for the current user' do
    expect{ do_request(params) }.to change(Consult, :count).by(1)
    expect(response).to be_success
    body = JSON.parse(response.body, symbolize_names: true)
    consult = Consult.find(body[:consult][:id])
    expect(body[:consult].to_json).to eq(consult.serializer.as_json.to_json)
    expect(consult.initiator).to eq(user)
    expect(consult.subject).to eq(user)
  end
end

shared_examples 'creates a message' do |num_messages|
  it 'creates a message' do
    expect{ do_request(params) }.to change(Message, :count).by(num_messages || 1)
    expect(response).to be_success
    body = JSON.parse(response.body, symbolize_names: true)
    consult = Consult.find(body[:consult][:id])
    expect(consult.messages.count).to eq(num_messages || 1)
  end
end

describe 'Consults' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }

  before do
    Role.find_or_create_by_name!(:pha)
  end

  context 'existing record' do
    let!(:consult) { create(:consult, initiator: user) }

    describe 'GET /api/v1/consults' do
      def do_request
        get "/api/v1/consults", auth_token: session.auth_token
      end

      it 'indexes the user\'s consults' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:consults]).to_not be_empty
        expect(body[:consults].map{|c| c[:id]}).to include(consult.id)
      end
    end

    describe 'GET /api/v1/consults/current' do
      def do_request
        get "/api/v1/consults/current", auth_token: session.auth_token
      end

      it 'shows the master consult' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:consult].to_json).to eq(user.reload.master_consult.serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/consults/:id' do
      def do_request
        get "/api/v1/consults/#{consult.id}", auth_token: session.auth_token
      end

      it 'shows a single consult' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:consult].to_json).to eq(consult.serializer.as_json.to_json)
      end
    end
  end

  describe 'POST /api/v1/consults' do
    def do_request(params={})
      post 'api/v1/consults', params.merge!(auth_token: session.auth_token)
    end

    let(:title) { 'test title' }
    let(:params) { {consult: {title: title}} }

    it_behaves_like 'creates a consult'

    context 'with a subject' do
      let!(:subject) { create(:user) }
      let(:params) { {consult: {title: title, subject_id: subject.id}} }

      it 'creates a new consult for the given subject' do
        expect{ do_request(params) }.to change(Consult, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        consult = Consult.find(body[:consult][:id])
        expect(body[:consult].to_json).to eq(consult.serializer.as_json.to_json)
        expect(consult.title).to eq(title)
        expect(consult.initiator).to eq(user)
        expect(consult.subject).to eq(subject)
      end
    end

    context 'with a message' do
      let(:text) { 'test message' }
      let(:params) { {consult: {title: title, message: {text: text}}} }

      it_behaves_like 'creates a consult'
      it_behaves_like 'creates a message'
    end

    context 'with a phone_call' do
      let(:phone_call_params) { {origin_phone_number: '5555555555',
                                 destination_phone_number: '1234567890'} }
      let(:params) { {consult: {title: title, phone_call: phone_call_params}} }

      it_behaves_like 'creates a consult'
      it_behaves_like 'creates a message'

      it 'creates a phone_call' do
        expect{ do_request(params) }.to change(PhoneCall, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        consult = Consult.find(body[:consult][:id])
        expect(consult.phone_calls.count).to eq(1)
      end
    end

    context 'with a scheduled_phone_call' do
      let!(:scheduled_phone_call) { create(:scheduled_phone_call, :assigned) }
      let(:scheduled_phone_call_params) { {callback_phone_number: '4083913578', scheduled_at: scheduled_phone_call.scheduled_at} }
      let(:params) { {consult: {title: title, scheduled_phone_call: scheduled_phone_call_params}} }

      it_behaves_like 'creates a consult'
      it_behaves_like 'creates a message', 2

      it 'books a scheduled_phone_call' do
        expect(scheduled_phone_call.state?(:assigned)).to be_true
        do_request(params)
        expect(scheduled_phone_call.reload.state?(:booked)).to be_true
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        consult = Consult.find(body[:consult][:id])
        expect(consult.scheduled_phone_calls.count).to eq(1)
      end
    end
  end
end
