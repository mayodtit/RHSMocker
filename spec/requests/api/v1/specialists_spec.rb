require 'spec_helper'

describe 'TaskCategories' do
  let!(:user) { create(:pha) }
  let!(:session) { user.sessions.create }

  context 'existing record' do
    let!(:specialist) { create(:specialist) }

    describe 'GET /api/v1/specialists' do
      def do_request
        get "/api/v1/specialists", auth_token: session.auth_token
      end

      it 'indexes specialists' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:specialists].to_json).to eq([specialist].serializer(specialist: true).as_json.to_json)
      end
    end
  end

  context 'existing specialist queue records' do
    let!(:specialist_task) { create(:task, :unclaimed, queue: :specialist, due_at: 1.day.ago) }
    describe 'GET /api/v1/specialists/queue' do
      def do_request
        get "/api/v1/specialists/queue", auth_token: session.auth_token
      end

      it 'should return the specialist queue for that day' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:queue].to_json).to eq([specialist_task].serializer(specialist: true).as_json.to_json)
      end
    end
  end
end
