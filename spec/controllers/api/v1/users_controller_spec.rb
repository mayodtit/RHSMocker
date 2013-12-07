require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(current_ability: ability)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    before do
      controller.stub(search_service: double('search_service', query: [user]))
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it_behaves_like 'success'

      it 'returns an array of users' do
        do_request
        json = JSON.parse(response.body, symbolize_names: true)
        json[:users].to_json.should == [user].as_json.to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the user' do
        do_request
        json = JSON.parse(response.body, symbolize_names: true)
        json[:user].to_json.should == user.as_json(only: [:first_name, :last_name, :email], methods: [:full_name, :admin?, :nurse?]).to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, user: attributes_for(:member)
    end

    before do
      Member.stub(:create => user)
    end

    it 'attempts to create the record' do
      Member.should_receive(:create).once
      do_request
    end

    context 'save succeeds' do
      it_behaves_like 'success'

      it 'returns the user' do
        do_request
        json = JSON.parse(response.body, symbolize_names: true)
        json[:user].to_json.should == user.as_json.to_json
      end
    end

    context 'save fails' do
      before(:each) do
        user.errors.add(:base, :invalid)
      end

      it_behaves_like 'failure'
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, user: attributes_for(:user)
    end

    before do
      user.stub(:update_attributes)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to update the record' do
        user.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before do
          user.stub(update_attributes: true)
        end

        it_behaves_like 'success'
      end

      context 'update_attributes fails' do
        before do
          user.stub(update_attributes: false)
          user.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT secure_update' do
    def do_request
      put :secure_update, user: attributes_for(:user).merge!(current_password: 'password')
    end

    before do
      user.stub(:update_attributes)
      controller.stub(:convert_legacy_parameters!)
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      before do
        controller.stub(login: false)
      end

      it_behaves_like 'failure'

      context 'password authenticated' do
        before do
          controller.stub(login: user)
        end

        it_behaves_like 'action requiring authorization'

        context 'authorized', user: :authorize! do
          it 'attempts to update the record' do
            user.should_receive(:update_attributes).once
            do_request
          end

          context 'update_attributes succeeds' do
            before do
              user.stub(update_attributes: true)
            end

            it_behaves_like 'success'
          end

          context 'update_attributes fails' do
            before do
              user.stub(update_attributes: false)
              user.errors.add(:base, :invalid)
            end

            it_behaves_like 'failure'
          end
        end
      end
    end
  end
end
