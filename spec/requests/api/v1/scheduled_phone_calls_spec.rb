require 'spec_helper'

describe 'ScheduledPhoneCall' do
  let(:user) { create(:member) }
  let(:session) { user.sessions.create }

  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  let(:near_timestamp) do
    prev_global_time_zone = Time.zone
    Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
    time = Time.roll_forward(1.days.from_now.in_time_zone(Time.zone)).on_call_start_oclock
    Time.zone = prev_global_time_zone
    time.utc
  end

  let(:future_timestamp) do
    prev_global_time_zone = Time.zone
    Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
    time = Time.roll_forward(10.days.from_now.in_time_zone(Time.zone)).on_call_start_oclock
    Time.zone = prev_global_time_zone
    time.utc
  end

  let(:past_timestamp) do
    prev_global_time_zone = Time.zone
    Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
    time = Time.roll_backward(3.days.ago.in_time_zone(Time.zone)).on_call_start_oclock
    Time.zone = prev_global_time_zone
    time.utc
  end

  describe 'GET /api/v1/scheduled_phone_calls/available' do
    def do_request
      get '/api/v1/scheduled_phone_calls/available', auth_token: session.auth_token
    end

    let!(:available) { create(:scheduled_phone_call, :assigned, scheduled_at: near_timestamp) }
    let!(:unavailable_state) { create(:scheduled_phone_call) }
    let!(:unavailable_time) { create(:scheduled_phone_call, :assigned, scheduled_at: past_timestamp) }

    it 'indexes available scheduled_phone_calls' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:scheduled_phone_calls].to_json).to eq([available].as_json.to_json)
    end

    context 'with free_trial_ends_at' do
      let!(:user) { create(:member, :trial, free_trial_ends_at: near_timestamp + 15.minutes) }
      let!(:future_time) { create(:scheduled_phone_call, :assigned, scheduled_at: future_timestamp) }

      it 'indexes available scheduled_phone_calls' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:scheduled_phone_calls].to_json).to eq([available].as_json.to_json)
      end
    end

    context 'with subscription_ends_at' do
      let!(:future_time) { create(:scheduled_phone_call, :assigned, scheduled_at: future_timestamp) }

      before do
        user.update_attributes!(status: :premium)
        user.reload.update_attributes!(subscription_ends_at: near_timestamp + 15.minutes)
      end

      it 'indexes available scheduled_phone_calls' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:scheduled_phone_calls].to_json).to eq([available].as_json.to_json)
      end
    end
  end

  describe 'GET /api/v1/scheduled_phone_calls/available_times' do
    def do_request
      get '/api/v1/scheduled_phone_calls/available_times', auth_token: session.auth_token
    end

    let!(:available) { create(:scheduled_phone_call, :assigned) }
    let!(:unavailable_state) { create(:scheduled_phone_call) }
    let!(:unavailable_time) { create(:scheduled_phone_call, :assigned, scheduled_at: past_timestamp) }

    it 'indexes available scheduled_phone_call times' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:times].to_json).to eq([available.scheduled_at].as_json.to_json)
    end
  end

  let(:user) { create(:admin) }

  context 'existing record' do
    let!(:scheduled_phone_call) { create(:scheduled_phone_call, user: user) }
    let(:id) { scheduled_phone_call.id }

    describe 'GET /api/v1/scheduled_phone_calls' do
      def do_request(params={})
        get "/api/v1/scheduled_phone_calls", params.merge!(auth_token: session.auth_token)
      end

      it 'indexes the scheduled_phone_calls' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:scheduled_phone_calls].to_json.should == [scheduled_phone_call].serializer(shallow: true).as_json.to_json
      end
    end

    describe 'GET /api/v1/scheduled_phone_calls/:id' do
      def do_request(params={})
        get "/api/v1/scheduled_phone_calls/#{id}", params.merge!(auth_token: session.auth_token)
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
        put "/api/v1/scheduled_phone_calls/#{id}", {auth_token: session.auth_token}.merge!(:scheduled_phone_call => params)
      end

      let(:time) do
        prev_global_time_zone = Time.zone
        Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
        time = Time.roll_forward(50.days.from_now.in_time_zone(Time.zone)).on_call_start_oclock + 1.hour
        Time.zone = prev_global_time_zone
        time.utc
      end

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
        delete "/api/v1/scheduled_phone_calls/#{id}", params.merge!(auth_token: session.auth_token)
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
        post "/api/v1/scheduled_phone_calls", params.merge!(auth_token: session.auth_token)
      end

      let(:time) do
        prev_global_time_zone = Time.zone
        Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
        time = Time.roll_forward(100.days.from_now.in_time_zone(Time.zone)).on_call_start_oclock
        Time.zone = prev_global_time_zone
        time.utc
      end
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
