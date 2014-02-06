require 'spec_helper'

describe Api::V1::PhoneCallsController do
  let(:user) do
    member = build_stubbed :member
    member.add_role :nurse
    member
  end

  let(:nurse_role) do
    Role.find_by_name! :nurse
  end

  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      before do
        @phone_calls = [build_stubbed(:phone_call), build_stubbed(:phone_call)]
        PhoneCall.stub(:where) {
          o = Object.new
          o.stub(:order).with('created_at ASC') {
            o_o = Object.new
            o_o.stub(:find_each).and_yield(@phone_calls[0]).and_yield(@phone_calls[1])
            o_o
          }
          o
        }
      end

      it_behaves_like 'success'

      it 'returns phone calls with the state parameter' do
        json = @phone_calls.as_json(
          include: {
            user: {
              only: [:first_name, :last_name, :email],
              methods: [:full_name]
            }
          }
        )

        controller.should_receive(:index_resource).with(json).and_call_original
        get :index, auth_token: user.auth_token, state: 'unclaimed'
      end

      it 'doesn\'t permit other query parameters' do
        PhoneCall.should_receive(:where).with('state' => 'unclaimed') {
          o = Object.new
          o.stub(:order).with('created_at ASC') {
            o_o = Object.new
            o_o.stub(:find_each).and_yield(@phone_calls[0]).and_yield(@phone_calls[1])
            o_o
          }
          o
        }
        get :index, auth_token: user.auth_token, state: 'unclaimed', member_id: '1'
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

      it 'dials destination' do
        phone_call.should_receive(:dial_destination)
        do_request
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

      it 'marks the destination as connected' do
        phone_call.should_receive(:update_attributes!).with(destination_status: PhoneCall::CONNECTED_STATUS)
        do_request
      end

      it_behaves_like 'success'
      it_behaves_like 'renders valid xml', 'phone_calls/connect_destination'
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
    end

    it_behaves_like 'success'

    it 'sets select url' do
      do_request
      assigns(:select_url).should == '/test'
    end

    it 'sets phas off duty' do
      PhoneCall.stub(:accepting_calls_to_pha?) { true }
      do_request
      assigns(:phas_off_duty).should == false
    end

    it 'resolves the phone call and assigns it' do
      PhoneCall.should_receive(:resolve).with('+14083913578', 'CA8f68d3676b5424bde1594cb34235076b')
      do_request
      assigns(:phone_call).should == phone_call
    end

    it_behaves_like 'renders valid xml', 'phone_calls/connect'
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
      end

      it_behaves_like 'success'

      it 'sets select url' do
        URL_HELPERS.stub(:triage_select_api_v1_phone_call_url).with(phone_call) { '/test' }
        do_request
        assigns(:select_url).should == '/test'
      end
    end
  end

  describe 'POST triage_select' do
    let(:phone_call) { build_stubbed :phone_call }

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
          phone_call.should_receive(:miss!)
          do_request
        end

        it 'renders goodbye' do
          do_request
          response.should render_template(:goodbye)
        end
      end

      context 'digits is 1' do
        let(:robot) { build(:member) }
        let(:nurseline_phone_call) { build(:phone_call) }

        before do
          Member.stub(:robot) { robot }
          phone_call.stub(:update_attributes)
        end

        it_behaves_like 'success'

        it 'transfers the phone call' do
          phone_call.should_receive(:update_attributes).with(state_event: :transfer, transferrer: robot)
          do_request('1')
        end

        it 'sets nurseline_phone_call' do
          phone_call.stub(:transferred_to_phone_call) { nurseline_phone_call }
          do_request('1')
          assigns(:nurseline_phone_call).should == nurseline_phone_call
        end

        it 'redirects to connect nurse' do
          do_request('1')
          response.should render_template(:connect_nurse)
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