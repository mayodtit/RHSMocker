require 'spec_helper'

describe Api::V1::ScheduledPhoneCallsController do
  let(:scheduled_phone_call) { build_stubbed(:scheduled_phone_call) }
  let(:scheduled_phone_calls) { [ build_stubbed(:scheduled_phone_call), build_stubbed(:scheduled_phone_call)] }
  let(:authorized_scheduled_phone_calls) { [ scheduled_phone_calls[0] ] }
  let(:user) { build_stubbed(:pha_lead) }
  let(:pha) { build_stubbed(:pha) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
  end

  describe '#filter_authorized_scheduled_phone_calls' do
    it 'filters out phone calls that can be read' do
      scheduled_phone_calls.stub(:find_each).and_yield(scheduled_phone_calls[0]).and_yield(scheduled_phone_calls[1])
      controller.stub(:can?).with(:read, scheduled_phone_calls[0]) { true }
      controller.stub(:can?).with(:read, scheduled_phone_calls[1]) { false }
      controller.send(:filter_authorized_scheduled_phone_calls, scheduled_phone_calls).should == authorized_scheduled_phone_calls
    end
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before do
      controller.stub(:filter_authorized_scheduled_phone_calls).with(scheduled_phone_calls) { authorized_scheduled_phone_calls }
      ScheduledPhoneCall.stub(:where) { scheduled_phone_calls }
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated and authorized', user: :authenticate! do
      it_behaves_like 'success'

      it 'returns an array of scheduled_phone_calls' do
        do_request
        json = JSON.parse(response.body)
        json['scheduled_phone_calls'].to_json.should == authorized_scheduled_phone_calls.serializer.to_json
      end

      it 'filters by only state, user_id, and owner_id' do
        ScheduledPhoneCall.stub(:where).with('state' => 'booked', 'user_id' => '2', 'owner_id' => '3') { scheduled_phone_calls }
        get :index, auth_token: user.auth_token, state: 'booked', user_id: 2, owner_id: 3, blah: 5
        json = JSON.parse(response.body)
        json['scheduled_phone_calls'].to_json.should == authorized_scheduled_phone_calls.serializer.to_json
      end

      it 'filters by scheduled_after' do
        Timecop.freeze
        ScheduledPhoneCall.stub(:where) do
          o = Object.new
          o.stub(:where).with('scheduled_at > ?', 3.days.ago.to_s) do
            scheduled_phone_calls
          end
          o
        end
        get :index, auth_token: user.auth_token, scheduled_after: 3.days.ago
        json = JSON.parse(response.body)
        json['scheduled_phone_calls'].to_json.should == authorized_scheduled_phone_calls.serializer.to_json
        Timecop.return
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    before do
      ScheduledPhoneCall.stub(:find) { scheduled_phone_call }
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the scheduled_phone_call' do
        do_request
        json = JSON.parse(response.body, symbolize_names: true)
        json[:scheduled_phone_call].to_json.should == scheduled_phone_call.serializer.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, scheduled_phone_call: scheduled_phone_call.as_json
    end

    before do
      ScheduledPhoneCall.stub(create: scheduled_phone_call)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to create the record' do
        ScheduledPhoneCall.should_receive(:create).once
        do_request
      end

      it 'creates and assigns when owner_id is passed in' do
        Timecop.freeze
        json = scheduled_phone_call.as_json
        json[:owner_id] = 1

        params = {}
        params['owner_id'] = '1'
        params['scheduled_at'] = json['scheduled_at'].to_s
        params['state'] = 'assigned'
        params['assignor_id'] = user.id
        params['assigned_at'] = Time.now

        ScheduledPhoneCall.should_receive(:create).with(params).once
        post :create, scheduled_phone_call: json
        Timecop.return
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the scheduled_phone_call' do
          do_request
          json = JSON.parse(response.body)
          json['scheduled_phone_call'].to_json.should == scheduled_phone_call.serializer.as_json.to_json
        end
      end

      context 'save fails' do
        before do
          scheduled_phone_call.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, scheduled_phone_call: attributes_for(:scheduled_phone_call)
    end

    before do
      ScheduledPhoneCall.stub(:find) { scheduled_phone_call }
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to update the record' do
        scheduled_phone_call.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before do
          scheduled_phone_call.stub(update_attributes: true)
        end

        it_behaves_like 'success'
      end

      context 'update_attributes fails' do
        before do
          scheduled_phone_call.stub(update_attributes: false)
          scheduled_phone_call.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT state_event' do
    def do_request(state_event = 'cancel')
      put :state_event, id: scheduled_phone_call.id, state_event: state_event
    end

    before do
      ScheduledPhoneCall.stub(:find) { scheduled_phone_call }
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      context 'scheduled phone call is not found' do
        before do
          ScheduledPhoneCall.stub(:find) { raise(ActiveRecord::RecordNotFound) }
        end

        it_behaves_like '404'
      end

      context 'scheduled phone call is found' do
        context 'and doesn\'t support state event' do
          def do_request
            put :state_event, id: scheduled_phone_call.id, state_event: 'fake'
          end

          it_behaves_like 'failure'

          it 'returns 422' do
            do_request
            response.status.should == 422
          end
        end

        context 'supports state event' do
          before do
            scheduled_phone_call.stub(:cancel).with(user, nil)
          end

          it 'calls the state event with the current user' do
            scheduled_phone_call.should_receive(:cancel).with(user, nil)
            do_request
          end

          context 'state event requires a subject (owner or user)' do
            def do_request
              put :state_event, id: scheduled_phone_call.id, state_event: 'assign', scheduled_phone_call: { owner_id: 10 }
            end

            context 'subject is not found' do
              before do
                Member.stub(:find).with('10') { raise(ActiveRecord::RecordNotFound) }
              end

              it_behaves_like '404'
            end

            context 'subject is found' do
              before do
                Member.stub(:find).with('10') { pha }
              end

              it 'calls the state event with the current user and subject' do
                scheduled_phone_call.should_receive(:assign).with(user, pha)
                do_request
              end
            end
          end

          context 'and succeeds' do
            it_behaves_like 'success'

            it 'renders the scheduled phone call' do
              do_request
              json = JSON.parse(response.body)
              json['scheduled_phone_call'].to_json.should == scheduled_phone_call.serializer.as_json.to_json
            end
          end

          context 'and fails' do
            before do
              scheduled_phone_call.stub(:valid?) { false }
            end

            it_behaves_like 'failure'
          end
        end
      end
    end
  end

  describe 'DELETE destroy' do
    def do_request
      delete :destroy
    end

    before do
      ScheduledPhoneCall.stub(:find) { scheduled_phone_call }
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        scheduled_phone_call.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before do
          scheduled_phone_call.stub(destroy: true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before do
          scheduled_phone_call.stub(destroy: false)
          scheduled_phone_call.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
