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
      end

      it_behaves_like 'success'
      it_behaves_like 'renders valid xml', 'phone_calls/connect_origin'

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
      end

      it_behaves_like 'success'
      it_behaves_like 'renders valid xml', 'phone_calls/connect_destination'
    end
  end

  describe 'POST connect' do
    def do_request
      post :connect
    end

    it_behaves_like 'success'
  end

  describe 'POST status_origin' do
    def do_request
      post :status_origin, id: '1'
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
      end

      it_behaves_like 'success'
    end
  end

  describe 'POST status_destination' do
    def do_request
      post :status_destination, id: '1'
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
      end

      it_behaves_like 'success'
    end
  end

  describe 'POST status' do
    let(:phone_call) { build_stubbed :phone_call }

    def do_request
      post :status
    end

    it_behaves_like 'success'
  end
end