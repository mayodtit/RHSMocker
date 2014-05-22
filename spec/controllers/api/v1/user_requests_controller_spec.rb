require 'spec_helper'

describe Api::V1::UserRequestsController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:user_requests) { double('user_requests') }

  before do
    controller.stub(current_ability: ability)
    user.stub(user_requests: user_requests)
  end

  context 'existing record' do
    let!(:user_request) { create(:user_request) }

    before do
      UserRequest.stub(find: user_request)
      user_requests.stub(find: user_request,
                         serializer: [user_request].serializer(root: :user_requests))
    end

    describe 'GET index' do
      def do_request
        get :index, auth_token: user.auth_token
      end

      it_behaves_like 'action requiring authentication and authorization'

      context 'authenticated and authorized', user: :authenticate_and_authorize! do
        it_behaves_like 'success'

        it 'returns an array of user_requests' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:user_requests].to_json).to eq([user_request].serializer.as_json.to_json)
        end
      end
    end

    describe 'GET show' do
      def do_request
        get :show, auth_token: user.auth_token
      end

      it_behaves_like 'action requiring authentication and authorization'

      context 'authenticated and authorized', user: :authenticate_and_authorize! do
        it_behaves_like 'success'

        it 'returns the user_request' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:user_request].to_json).to eq(user_request.serializer.as_json[:user_request].to_json)
        end
      end
    end

    describe 'PUT update' do
      def do_request
        put :update, auth_token: user.auth_token, user_request: attributes_for(:user_request)
      end

      before do
        user_request.stub(:update_attributes)
      end

      it_behaves_like 'action requiring authentication and authorization'

      context 'authenticated and authorized', user: :authenticate_and_authorize! do
        it 'attempts to update the record' do
          user_request.should_receive(:update_attributes).once
          do_request
        end

        context 'update_attributes succeeds' do
          before do
            user_request.stub(update_attributes: true)
          end

          it_behaves_like 'success'
        end

        context 'update_attributes fails' do
          before do
            user_request.stub(update_attributes: false)
            user_request.errors.add(:base, :invalid)
          end

          it_behaves_like 'failure'
        end
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, user_request: attributes_for(:user_request)
    end

    let(:user_request) { build_stubbed(:user_request) }

    before do
      user_requests.stub(create: user_request)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to create the record' do
        user_requests.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the user_request' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:user_request].to_json).to eq(user_request.serializer.as_json[:user_request].to_json)
        end
      end

      context 'save fails' do
        before(:each) do
          user_request.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
