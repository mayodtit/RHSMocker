require 'spec_helper'

describe 'ScheduledCommunications' do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  let(:pha) { create(:pha) }
  let(:member) { create(:member, :premium, pha: pha) }

  context 'existing record' do
    let!(:scheduled_communication) { create(:scheduled_message, sender: pha, recipient: member) }

    describe 'GET /api/v1/users/:user_id/scheduled_communications' do
      def do_request
        get "/api/v1/users/#{member.id}/scheduled_communications", auth_token: pha.auth_token
      end

      it 'indexes scheduled_communications' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:scheduled_communications].to_json).to eq([scheduled_communication].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/:user_id/scheduled_communications/:id' do
      def do_request
        get "/api/v1/users/#{member.id}/scheduled_communications/#{scheduled_communication.id}", auth_token: pha.auth_token
      end

      it 'shows the scheduled_communication' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:scheduled_communication].to_json).to eq(scheduled_communication.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/users/:user_id/scheduled_communications/:id' do
      def do_request(params={})
        put "/api/v1/users/#{member.id}/scheduled_communications/#{scheduled_communication.id}", params.merge!(auth_token: pha.auth_token)
      end

      let(:new_publish_at) { Time.now + 5.days }

      it 'updates the scheduled_communication' do
        do_request(scheduled_communication: {publish_at: new_publish_at})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(scheduled_communication.reload.publish_at).to eq(new_publish_at)
        expect(body[:scheduled_communication].to_json).to eq(scheduled_communication.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/users/:user_id/scheduled_communications/:id' do
      def do_request
        delete "/api/v1/users/#{member.id}/scheduled_communications/#{scheduled_communication.id}", auth_token: pha.auth_token
      end

      it 'destroys the scheduled_communication' do
        do_request
        expect(response).to be_success
        expect(ScheduledCommunication.find_by_id(scheduled_communication.id)).to be_nil
      end
    end
  end
end
