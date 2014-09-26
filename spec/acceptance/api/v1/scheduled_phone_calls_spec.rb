require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "ScheduledPhoneCalls" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  context 'as a Member' do
    let!(:user) { create(:member) }
    let(:session) { user.sessions.create }
    let!(:scheduled_phone_call) { create(:scheduled_phone_call, :assigned) }
    let(:auth_token) { session.auth_token }

    parameter :auth_token, "Performing user's auth_token"
    required_parameters :auth_token

    get '/api/v1/scheduled_phone_calls/available' do
      example_request '[GET] Get available ScheduledPhoneCalls' do
        explanation 'Returns an array of ScheduledPhoneCalls'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:scheduled_phone_calls].to_json).to eq([scheduled_phone_call].as_json.to_json)
      end
    end

    get '/api/v1/scheduled_phone_calls/available_times' do
      example_request '[GET] Get available ScheduledPhoneCall times' do
        explanation 'Returns an array of ScheduledPhoneCall times'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:times].to_json).to eq([scheduled_phone_call.scheduled_at].as_json.to_json)
      end
    end
  end

  context 'as a PHA' do
    let!(:member) { create(:member) }
    let!(:user) { create(:pha_lead) }
    let(:session) { user.sessions.create }
    let!(:pha) { create(:pha) }
    let(:auth_token) { session.auth_token }

    parameter :auth_token, "Performing user's auth_token"
    required_parameters :auth_token

    context 'existing records' do
      # NOTE: Keep order of creates, tests order
      before do
        prev_global_time_zone = Time.zone
        Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
        @future = Time.roll_forward(200.days.from_now.in_time_zone(Time.zone)).utc
        @past = Time.roll_backward(3.days.ago.in_time_zone(Time.zone)).utc
        Time.zone = prev_global_time_zone
      end

      let!(:another_scheduled_phone_call) { create(:scheduled_phone_call, :scheduled_at => @future) }
      let!(:scheduled_phone_call) { create(:scheduled_phone_call) }
      let!(:other_scheduled_phone_call) { create(:scheduled_phone_call, :scheduled_at => @past) }
      let(:id) { scheduled_phone_call.id }

      describe 'phone_calls' do
        parameter :user_id, 'Filter by the person that is booked for the scheduled phone call.'
        parameter :owner_id, 'Filter by the HCP that owns the scheduled phone call.'
        parameter :state, 'Filter by the state of the scheduled phone call. Supports an array of states.'
        parameter :scheduled_after, 'Filter by calls after the specified date.'

        let(:scheduled_after) { Time.now }

        get '/api/v1/scheduled_phone_calls' do
          example_request "[GET] Get all scheduled_phone_calls" do
            explanation "Returns an array of scheduled_phone_calls. Can be filtered by state, user_id, owner_id and/or scheduled_after (DateTime)"
            status.should == 200
            body = JSON.parse(response_body, :symbolize_names => true)
            body[:scheduled_phone_calls].to_json.should == [scheduled_phone_call, another_scheduled_phone_call].serializer(shallow: true).to_json
          end
        end
      end

      get '/api/v1/scheduled_phone_calls/:id' do
        example_request "[GET] Get a scheduled_phone_call" do
          explanation "Returns the scheduled_phone_call"
          status.should == 200
          body = JSON.parse(response_body, :symbolize_names => true)
          body[:scheduled_phone_call].to_json.should == scheduled_phone_call.serializer.to_json
        end
      end

      put '/api/v1/scheduled_phone_calls/:id' do
        let!(:scheduled_phone_call) { create(:scheduled_phone_call, :assigned, :w_message) }

        parameter :scheduled_at, 'Time for when the call is scheduled'
        parameter :state_event, 'Event to transition phone call state through'
        parameter :user_id, 'The member who booked this call'
        parameter :callback_phone_number, "The member's preferred callback number"

        let(:state_event) { 'book' }
        let(:user_id) { member.id }
        let(:scheduled_at) do
          prev_global_time_zone = Time.zone
          Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
          time = Time.roll_forward(50.days.from_now.in_time_zone(Time.zone))
          Time.zone = prev_global_time_zone
          time.utc
        end
        let(:callback_phone_number) { '5551234567' }
        let(:raw_post) { params.to_json }

        example_request "[PUT] Update a scheduled_phone_call" do
          explanation "Updates and returns the scheduled_phone_call"
          status.should == 200
          body = JSON.parse(response_body, :symbolize_names => true)
          body[:scheduled_phone_call][:id].should == scheduled_phone_call.id
          body[:scheduled_phone_call][:scheduled_at].to_json.should == scheduled_at.utc.to_json
        end
      end

      delete '/api/v1/scheduled_phone_calls/:id' do
        let(:raw_post) { params.to_json }

        example_request "[DELETE] Delete a scheduled_phone_call" do
          explanation "Deletes the scheduled_phone_call"
          status.should == 200
        end
      end
    end

    post '/api/v1/scheduled_phone_calls' do
      parameter :scheduled_at, 'Time for when the call is scheduled'
      let(:scheduled_at) do
        prev_global_time_zone = Time.zone
        Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
        time = Time.roll_forward(100.days.from_now.in_time_zone(Time.zone))
        Time.zone = prev_global_time_zone
        time.utc
      end
      let(:raw_post) { params.to_json }

      example_request "[POST] Create a scheduled_phone_call" do
        explanation "Creates a scheduled_phone_call"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        ScheduledPhoneCall.find(body[:scheduled_phone_call][:id]).scheduled_at.to_json.should == scheduled_at.utc.to_json
      end
    end
  end
end
