require 'spec_helper'

describe Api::V1::PhoneCallsController do
  let(:user) { build_stubbed(:member).tap{|u| u.add_role(:nurse)} }
  let(:nurse_role) { Role.find_by_name!(:nurse) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    Role.find_or_create_by_name('nurse')
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request(params={})
      get :index, params.merge!(auth_token: user.auth_token)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      let(:phone_calls) { [build_stubbed(:phone_call), build_stubbed(:phone_call)] }

      before do
        PhoneCall.stub_chain(:where, :includes, :order).and_return(phone_calls)
      end

      it_behaves_like 'success'

      it 'returns phone calls with the state parameter' do
        do_request(state: 'unclaimed')
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:phone_calls].to_json).to eq(phone_calls.serializer.as_json.to_json)
      end

      it "doesn't permit other query parameters" do
        PhoneCall.should_receive(:where).with('state' => 'unclaimed')
        do_request(state: 'unclaimed', claimer_id: 1)
      end
    end
  end

  shared_examples 'phone call 404' do
    context 'phone call doesn\'t exist' do
      before do
        PhoneCall.stub(:find) { raise(ActiveRecord::RecordNotFound) }
      end

      it_behaves_like '404'
    end
  end

  describe 'GET show' do
    let(:phone_call) { build_stubbed :phone_call }

    def do_request
      get :show, auth_token: user.auth_token, id: phone_call.id
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'phone call 404'

      context 'phone call exists' do
        before do
          PhoneCall.stub(:find) { phone_call }
        end

        it_behaves_like 'success'
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, auth_token: user.auth_token, phone_call: {destination_phone_number: '5555555555'}
    end

    let!(:consult) { build_stubbed(:consult, initiator: user) }
    let!(:message) { build_stubbed(:message, user: user, consult: consult) }
    let!(:phone_call) { build_stubbed(:phone_call, message: message) }
    let(:phone_calls) { double('phone_calls', create: phone_call) }

    before do
      Consult.stub(find: consult)
      consult.stub(phone_calls: phone_calls)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to create the record' do
        phone_calls.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the phone_call' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:phone_call].to_json).to eq(phone_call.serializer.as_json.to_json)
        end
      end

      context 'save fails' do
        before do
          phone_call.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT update' do
    let(:phone_call) { build_stubbed :phone_call }

    def do_request
      put :update, auth_token: user.auth_token, id: phone_call.id, phone_call: {state_event: 'claim'}
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'phone call 404'

      context 'phone call exists' do
        before do
          PhoneCall.stub(:find) { phone_call }
        end

        context 'state event is present' do
          it 'sets the actor to the current user' do
            phone_call.should_receive(:update_attributes).with(
              'state_event' => 'claim',
              'claimer' => user
            )

            do_request
          end

          context 'and valid' do
            context 'update is valid' do
              before do
                phone_call.stub(:update_attributes) { true }
              end

              it_behaves_like 'success'
            end

            context 'update is not valid' do
              before do
                phone_call.stub(:update_attributes) { false }
              end

              it_behaves_like 'failure'
            end
          end
        end

        context 'state event is not present' do
          def do_request
            put :update, auth_token: user.auth_token, id: phone_call.id
          end

          it_behaves_like 'failure'
        end
      end
    end
  end

  describe 'POST connect_origin' do
    let(:phone_call) { build_stubbed :phone_call }

    def do_request
      post :connect_origin, id: '1'
    end

    before do
      phone_call.stub(:save!)
    end

    context 'phone call doesn\'t exist' do
      before do
        PhoneCall.stub(:find).with('1') { raise ActiveRecord::RecordNotFound }
      end

      it_behaves_like 'phone call 404'
    end

    context 'phone call exists' do
      let(:phone_call) { build_stubbed :phone_call }

      before do
        PhoneCall.stub(:find).with('1') { phone_call }
        phone_call.stub(:update_attributes!)
      end

      it_behaves_like 'success'
      it_behaves_like 'renders valid xml', 'phone_calls/connect_origin'

      it 'marks the origin as connected' do
        phone_call.should_receive(:update_attributes!).with(origin_status: PhoneCall::CONNECTED_STATUS)
        do_request
      end

      context 'phone call is still dialing' do
        before do
          phone_call.stub(:dialing?) { true }
        end

        it 'dials destination' do
          phone_call.should_receive(:dial_destination)
          do_request
        end
      end

      context 'phone call is not dialing' do
        before do
          phone_call.stub(:dialing?) { false }
        end

        it 'dials destination' do
          phone_call.should_not_receive(:dial_destination)
          do_request
        end
      end
    end
  end

  describe 'POST connect_destination' do
    def do_request
      post :connect_destination, id: '1'
    end

    context 'phone call doesn\'t exist' do
      before do
        PhoneCall.stub(:find).with('1') { raise ActiveRecord::RecordNotFound }
      end

      it_behaves_like 'phone call 404'
    end

    context 'phone call exists' do
      let(:phone_call) { build_stubbed :phone_call }

      before do
        PhoneCall.stub(:find).with('1') { phone_call }
        phone_call.stub(:update_attributes!)
      end

      it_behaves_like 'success'
      it_behaves_like 'renders valid xml', 'phone_calls/connect_destination'

      it 'marks the destination as connected' do
        phone_call.should_receive(:update_attributes!).with(destination_status: PhoneCall::CONNECTED_STATUS)
        do_request
      end

      context 'phone call is still dialing' do
        before do
          phone_call.stub(:dialing?) { true }
        end

        it 'dials origin' do
          phone_call.should_receive(:dial_origin)
          do_request
        end
      end

      context 'phone call is not dialing' do
        before do
          phone_call.stub(:dialing?) { false }
        end

        it 'dials origin' do
          phone_call.should_not_receive(:dial_origin)
          do_request
        end
      end
    end
  end

  describe 'POST connect' do
    let(:phone_call) { build(:phone_call) }

    def do_request
      post :connect, From: '+14083913578', CallSid: 'CA8f68d3676b5424bde1594cb34235076b'
    end

    before do
      PhoneCall.stub(:resolve) { phone_call }
      URL_HELPERS.stub(:triage_select_api_v1_phone_call_url).with(phone_call) { '/test' }
      URL_HELPERS.stub(:triage_menu_api_v1_phone_call_url).with(phone_call) { '/menu' }
    end

    it_behaves_like 'success'

    it 'sets select url' do
      do_request
      assigns(:select_url).should == '/test'
    end

    it 'sets menu url' do
      do_request
      assigns(:menu_url).should == '/menu'
    end

    it 'sets phas off duty' do
      Role.stub(:find_by_name!).with(:pha) do
        o = Object.new
        o.stub(:on_call?) { true }
        o
      end
      do_request
      assigns(:phas_off_duty).should == false
    end

    it 'sets whether the pha queue is enabled' do
      controller.stub(:queue_enabled?) { false }
      do_request
      assigns(:send_to_queue).should == false
    end

    it 'sets whether the pha queue is enabled' do
      controller.stub(:queue_enabled?) { true }
      do_request
      assigns(:send_to_queue).should == true
    end

    it 'resolves the phone call and assigns it' do
      PhoneCall.should_receive(:resolve).with('+14083913578', 'CA8f68d3676b5424bde1594cb34235076b')
      do_request
      assigns(:phone_call).should == phone_call
    end

    it_behaves_like 'renders valid xml', 'phone_calls/connect'
  end

  describe 'POST connect_nurse' do
    let(:phone_call) { build(:phone_call) }

    def do_request
      post :connect_nurse, From: '+14083913578', CallSid: 'CA8f68d3676b5424bde1594cb34235076b'
    end

    before do
      PhoneCall.stub(:resolve) { phone_call }
    end

    it_behaves_like 'success'

    it 'resolves the phone call and assigns it' do
      PhoneCall.should_receive(:resolve).with('+14083913578', 'CA8f68d3676b5424bde1594cb34235076b', Role.nurse)
      do_request
      assigns(:phone_call).should == phone_call
    end

    it_behaves_like 'renders valid xml', 'phone_calls/connect_nurse'
  end

  describe 'GET triage_menu' do
    let(:phone_call) { build_stubbed :phone_call }

    def do_request
      get :triage_menu, id: '1'
    end

    it_behaves_like 'phone call 404'

    context 'phone call exists' do
      before do
        PhoneCall.stub(:find) { phone_call }
        URL_HELPERS.stub(:triage_select_api_v1_phone_call_url).with(phone_call) { '/test' }
        URL_HELPERS.stub(:triage_menu_api_v1_phone_call_url).with(phone_call) { '/menu' }
      end

      it_behaves_like 'success'

      it 'sets menu url' do
        do_request
        assigns(:menu_url).should == '/menu'
      end

      it 'sets select url' do
        do_request
        assigns(:select_url).should == '/test'
      end
    end
  end

  describe 'POST triage_select' do
    let(:phone_call) { build_stubbed :phone_call }

    before do
      Role.stub(:find_by_name!).with(:nurse) { build_stubbed :role, name: 'nurse' }
      Role.stub(:find_by_name!).with(:pha) { build_stubbed :role, name: 'pha' }
      PhoneCall.any_instance.stub(:save!)
      PhoneCall.any_instance.stub(:dial_destination)
      MessageTask.stub(:create!)
    end

    def do_request(digits = '*')
      post :triage_select, Digits: digits, id: '1'
    end

    it_behaves_like 'phone call 404'

    context 'phone call exists' do
      before do
        phone_call.stub(:miss!)
        PhoneCall.stub(:find) { phone_call }
      end

      context 'digits is *' do
        it_behaves_like 'success'

        it 'marks the call as missed' do
          phone_call.should_receive(:miss!).with('after_hours')
          do_request
        end

        it 'renders goodbye' do
          do_request
          response.should render_template(:goodbye)
        end
      end

      context 'digits is 1' do
        let(:robot) { build_stubbed(:member) }
        let(:nurseline_phone_call) { build(:phone_call) }

        before do
          Member.stub(:robot) { robot }
          phone_call.stub(:update_attributes)
        end

        it_behaves_like 'success'

        it 'transfers the phone call' do
          phone_call.should_receive(:transfer!)
          do_request('1')
        end

        it 'sets nurseline_phone_call' do
          phone_call.stub(:transferred_to_phone_call) { nurseline_phone_call }
          do_request('1')
          assigns(:nurseline_phone_call).should == nurseline_phone_call
        end

        it 'marks the call as missed' do
          phone_call.should_receive(:miss!).with('after_hours')
          do_request('1')
        end

        it 'redirects to connect nurse' do
          do_request('1')
          response.should render_template(:transfer_nurse)
        end
      end

      context 'digits is any other number' do
        it_behaves_like 'success'

        it 'redirects to triage menu' do
          do_request('3')
          response.should redirect_to(action: :triage_menu, id: phone_call.id)
        end
      end
    end
  end

  describe 'POST status_origin' do
    def do_request
      post :status_origin, id: '1', CallStatus: 'completed'
    end

    context 'phone call doesn\'t exist' do
      before do
        PhoneCall.stub(:find).with('1') { raise ActiveRecord::RecordNotFound }
      end

      it_behaves_like 'phone call 404'
    end

    context 'phone call exists' do
      let(:phone_call) { build_stubbed :phone_call }

      before do
        PhoneCall.stub(:find).with('1') { phone_call }
        phone_call.stub(:update_attributes!)
      end

      it_behaves_like 'success'

      context 'disconnected call status' do
        before do
          controller.stub(:disconnected_call_status?) { true }
        end

        it 'disconnects with origin status' do
          phone_call.should_receive(:update_attributes!).with(state_event: 'disconnect', origin_status: 'completed')
          do_request
        end
      end

      context 'not disconnected call status' do
        before do
          controller.stub(:disconnected_call_status?) { false }
        end

        it 'sets origin status' do
          phone_call.should_receive(:update_attributes!).with(origin_status: 'completed')
          do_request
        end
      end
    end
  end

  describe 'POST status_destination' do
    def do_request
      post :status_destination, id: '1', CallStatus: 'completed'
    end

    context 'phone call doesn\'t exist' do
      before do
        PhoneCall.stub(:find).with('1') { raise ActiveRecord::RecordNotFound }
      end

      it_behaves_like 'phone call 404'
    end

    context 'phone call exists' do
      let(:phone_call) { build_stubbed :phone_call }

      before do
        PhoneCall.stub(:find).with('1') { phone_call }
        phone_call.stub(:update_attributes!)
      end

      it_behaves_like 'success'

      context 'disconnected call status' do
        before do
          controller.stub(:disconnected_call_status?) { true }
        end

        it 'disconnects with destination status' do
          phone_call.should_receive(:update_attributes!).with(state_event: 'disconnect', destination_status: 'completed')
          do_request
        end
      end

      context 'not disconnected call status' do
        before do
          controller.stub(:disconnected_call_status?) { false }
        end

        it 'sets destination status' do
          phone_call.should_receive(:update_attributes!).with(destination_status: 'completed')
          do_request
        end
      end
    end
  end

  describe 'POST status' do
    let(:phone_call) { build_stubbed :phone_call }

    def do_request
      post :status, CallSid: '1', CallStatus: 'completed'
    end

    it_behaves_like 'success'

    context 'phone call exists' do
      before do
        PhoneCall.stub(:find_by_origin_twilio_sid).with('1') { phone_call }
      end

      context 'disconnected call status' do
        before do
          controller.stub(:disconnected_call_status?) { true }
        end

        it 'disconnects with origin status' do
          phone_call.should_receive(:update_attributes!).with(state_event: 'disconnect', origin_status: 'completed')
          do_request
        end
      end

      context 'not disconnected call status' do
        before do
          controller.stub(:disconnected_call_status?) { false }
        end

        it 'sets origin status' do
          phone_call.should_receive(:update_attributes!).with(origin_status: 'completed')
          do_request
        end
      end
    end
  end

  describe 'PUT hang_up' do
    let(:phone_call) { build_stubbed :phone_call }

    def do_request
      put :hang_up, auth_token: user.auth_token, id: phone_call.id
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'phone call 404'

      context 'phone call exists' do
        before do
          PhoneCall.stub(:find) { phone_call }
        end

        it_behaves_like 'success'

        it 'hangs up the phone call' do
          phone_call.should_receive :hang_up
          do_request
        end
      end
    end
  end

  describe 'PUT transfer' do
    let(:phone_call) { build_stubbed :phone_call }

    def do_request
      put :transfer, auth_token: user.auth_token, id: phone_call.id
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'phone call 404'

      context 'phone call exists' do
        before do
          PhoneCall.stub(:find) { phone_call }
          phone_call.stub(:transfer!)
        end

        it_behaves_like 'success'

        it 'transfers the phone call' do
          phone_call.should_receive :transfer!
          do_request
        end
      end
    end
  end

  describe 'PUT merge' do
    let(:phone_call) { build_stubbed :phone_call }
    let(:member) { build_stubbed :user }

    def do_request(caller_id = member.id)
      put :merge, auth_token: user.auth_token, id: phone_call.id, caller_id: caller_id
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'phone call 404'

      context 'phone call exists' do
        before do
          PhoneCall.stub(:find) { phone_call }
        end

        context 'user id is present' do
          context 'unresolved call does not exist' do
            before do
              PhoneCall.stub(:where).with(state: :unresolved, user_id: member.id.to_s) do
                o = Object.new
                o.stub(:last) { nil }
                o
              end
            end

            it 'updates resource with the current user' do
              phone_call.should_receive(:update_attributes).with(user_id: member.id.to_s) { true }
              do_request
              body = JSON.parse(response.body, symbolize_names: true)
              body[:phone_call].to_json.should == phone_call.serializer.as_json.to_json
            end
          end

          context 'unresolved call exists' do
            let(:unresolved_phone_call) { build_stubbed :phone_call }

            before do
              PhoneCall.stub(:where).with(state: :unresolved, user_id: member.id.to_s) do
                o = Object.new
                o.stub(:last) { unresolved_phone_call }
                o
              end
            end

            context 'unresolved call is not within 10m of current call' do
              before do
                unresolved_phone_call.stub(:created_at) { phone_call.created_at - 11.minutes }
              end

              it 'updates resource with the current user' do
                phone_call.should_receive(:update_attributes).with(user_id: member.id.to_s) { true }
                do_request
                body = JSON.parse(response.body, symbolize_names: true)
                body[:phone_call].to_json.should == phone_call.serializer.as_json.to_json
              end
            end

            context 'unresolved call is within 10m of current call' do
              before do
                unresolved_phone_call.stub(:update_attributes)
                unresolved_phone_call.stub(:created_at) { phone_call.created_at - 10.minutes }
                phone_call.stub(:reload) { phone_call }
              end

              it 'updates the unresolved call' do
                unresolved_phone_call.should_receive(:update_attributes).with state_event: :merge, merged_into_phone_call: phone_call
                do_request
              end

              context 'unresolved call update is valid' do
                before do
                  unresolved_phone_call.stub(:valid?) { true }
                end

                it 'returns the phone call' do
                  do_request
                  body = JSON.parse(response.body, symbolize_names: true)
                  body[:phone_call].to_json.should == phone_call.serializer.as_json.to_json
                end
              end

              context 'unresolved call update is not valid' do
                before do
                  unresolved_phone_call.stub(:valid?) { false }
                  unresolved_phone_call.stub_chain(:full_messages, :to_sentence) { 'test' }
                end

                it_behaves_like 'failure'
              end
            end
          end
        end

        context 'user id is not present' do
          def do_request
            put :merge, auth_token: user.auth_token
          end

          it_behaves_like 'failure'
        end
      end
    end
  end

  describe '#disconnected_call_status?' do
    let(:params) { {} }

    before do
      controller.stub(:params) { params }
    end

    it 'returns false for "ringing"' do
      params['CallStatus'] = 'ringing'
      controller.send(:disconnected_call_status?).should be_false
    end

    it 'returns false for "in-progress"' do
      params['CallStatus'] = 'in-progress'
      controller.send(:disconnected_call_status?).should be_false
    end

    it 'returns false for "queued"' do
      params['CallStatus'] = 'queued'
      controller.send(:disconnected_call_status?).should be_false
    end

    it 'return true for "completed"' do
      params['CallStatus'] = 'completed'
      controller.send(:disconnected_call_status?).should be_true
    end

    it 'return true for "busy"' do
      params['CallStatus'] = 'busy'
      controller.send(:disconnected_call_status?).should be_true
    end

    it 'return true for "failed"' do
      params['CallStatus'] = 'failed'
      controller.send(:disconnected_call_status?).should be_true
    end

    it 'return true for "no-answer"' do
      params['CallStatus'] = 'no-answer'
      controller.send(:disconnected_call_status?).should be_true
    end

    it 'return true for "canceled"' do
      params['CallStatus'] = 'canceled'
      controller.send(:disconnected_call_status?).should be_true
    end
  end
end
