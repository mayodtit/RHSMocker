require 'spec_helper'

describe Api::V1::PhoneCallsController do
  let(:user) { build_stubbed :member }
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
        @json = [{},{}]
        PhoneCall.stub(:where) {
          o = Object.new
          o.stub(:order).with('created_at DESC') {
            o_o = Object.new
            o_o.stub(:as_json) { @json }
            o_o
          }
          o
        }
      end

      it_behaves_like 'success'

      it 'returns phone calls with the state parameter' do
        controller.should_receive(:index_resource).with(@json).and_call_original
        get :index, auth_token: user.auth_token, state: 'unclaimed'
      end

      it 'doesn\'t permit other query parameters' do
        PhoneCall.should_receive(:where).with('state' => 'unclaimed') {
          o = Object.new
          o.stub(:order).with('created_at DESC') {
            o_o = Object.new
            o_o.stub(:as_json) { @json }
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
          context 'and invalid' do
            def do_request
              put :update, auth_token: user.auth_token, id: phone_call.id, phone_call: {state_event: 'explode'}
            end

            it_behaves_like 'failure'
          end

          context 'and valid' do
            before do
              phone_call.stub(:claim)
            end

            it 'calls the state event' do
              received = false
              phone_call.stub(:respond_to?).with(:claim) { true }
              phone_call.should_receive(:send).at_least(:once) do |f, arg0, arg1|
                if f == :claim && arg0 == user && arg1 == nil
                  received = true
                end
              end

              do_request
            end

            context 'update is valid' do
              before do
                phone_call.stub(:valid?) { true }
              end

              it_behaves_like 'success'
            end

            context 'update is not valid' do
              before do
                phone_call.stub(:valid?) { false }
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
end