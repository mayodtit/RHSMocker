require 'spec_helper'

describe 'ScheduledPhoneCall' do
  let(:user) { create(:admin) }

  context 'existing record' do
    let!(:scheduled_phone_call) { create(:scheduled_phone_call, user: user) }
    let(:id) { scheduled_phone_call.id }

    describe 'GET /api/v1/scheduled_phone_calls' do
      def do_request(params={})
        get "/api/v1/scheduled_phone_calls", params.merge!(auth_token: user.auth_token)
      end

      it 'indexes the scheduled_phone_calls' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:scheduled_phone_calls].to_json.should == [scheduled_phone_call].serializer.as_json.to_json
      end
    end

    describe 'GET /api/v1/scheduled_phone_calls/:id' do
      def do_request(params={})
        get "/api/v1/scheduled_phone_calls/#{id}", params.merge!(auth_token: user.auth_token)
      end

      it 'shows the scheduled_phone_call' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:scheduled_phone_call].to_json.should == scheduled_phone_call.serializer.as_json.to_json
      end
    end

    describe 'PUT /api/v1/scheduled_phone_calls/:id' do
      def do_request(params={})
        put "/api/v1/scheduled_phone_calls/#{id}", {auth_token: user.auth_token}.merge!(:scheduled_phone_call => params)
      end

      let(:time) { Time.parse('04-10-1986').utc }

      it 'updates the record' do
        scheduled_phone_call.scheduled_at.should_not == time
        do_request(:scheduled_at => time)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:scheduled_phone_call].to_json.should == scheduled_phone_call.reload.serializer.as_json.to_json
        scheduled_phone_call.scheduled_at.to_json.should == time.as_json.to_json
      end
    end

    describe 'DELETE /api/v1/scheduled_phone_calls/:id' do
      def do_request(params={})
        delete "/api/v1/scheduled_phone_calls/#{id}", params.merge!(auth_token: user.auth_token)
      end

      it 'soft-deletes the record' do
        scheduled_phone_call.disabled_at.should be_nil
        expect{ do_request }.to change(ScheduledPhoneCall, :count).by(-1)
        response.should be_success
        scheduled_phone_call.reload.disabled_at.should_not be_nil
        scheduled_phone_call.should be_persisted
      end
    end
  end

  context 'creating a record' do
    describe 'POST /api/v1/scheduled_phone_calls' do
      def do_request(params={})
        post "/api/v1/scheduled_phone_calls", params.merge!(auth_token: user.auth_token)
      end

      let(:time) { Time.parse('04-10-1986').utc }
      let(:attributes) { {:scheduled_at => time} }

      it 'creates a new scheduled_phone_call' do
        expect{ do_request(:scheduled_phone_call => attributes) }.to change(ScheduledPhoneCall, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:scheduled_phone_call][:scheduled_at].to_json.should == attributes[:scheduled_at].to_json
      end
    end
  end
end
