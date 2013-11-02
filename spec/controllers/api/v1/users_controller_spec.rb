require 'spec_helper'

# TODO: This is incomplete
describe Api::V1::UsersController do
  let(:user) { build_stubbed :member }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', :user => :authenticate! do
      it_behaves_like 'success'

      it 'renders with the full name' do
        user.stub(:full_name) { 'Michael' }
        do_request
        json = JSON.parse(response.body)
        json['user']['full_name'].should == user.full_name
      end
    end
  end

  describe 'GET check_reset_password' do
    context 'token missing' do
      def do_request
        get :check_reset_password
      end

      it_behaves_like 'failure'

      it 'returns 400' do
        do_request
        response.status.should == 400
      end
    end

    context 'token present' do
      context 'token expired' do
        def do_request
          get :check_reset_password, token: 'EXPIRED_TOKEN'
        end

        it_behaves_like 'failure'

        it 'returns 410' do
          do_request
          response.status.should == 410
        end
      end

      context 'token exists' do
        def do_request
          Member.stub(:find_by_reset_password_token) {
            user
          }

          get :check_reset_password, token: 'TOKEN'
        end

        it_behaves_like 'success'
      end
    end
  end

  describe 'PUT update_password_from_reset' do
    context 'token missing' do
      def do_request
        get :update_password_from_reset
      end

      it_behaves_like 'failure'

      it 'returns 400' do
        do_request
        response.status.should == 400
      end
    end

    context 'token present' do
      context 'token expired' do
        def do_request
          get :update_password_from_reset, token: 'EXPIRED_TOKEN'
        end

        it_behaves_like 'failure'

        it 'returns 410' do
          do_request
          response.status.should == 410
        end
      end

      context 'token exists' do
        before do
          Member.stub(:find_by_reset_password_token) {
            user
          }
        end

        def do_request
          member = {password: 'password', password_confirmation: 'password'}
          get :update_password_from_reset, token: 'EXPIRED_TOKEN', member: member
        end

        context 'change password fails' do
          before do
            user.stub(:change_password!) {
              # Not the actual exception raised
              raise(ActiveRecord::RecordNotFound)
            }
          end

        end

        context 'change password succeeds' do
          before do
            user.stub :change_password! => true
          end

          it_behaves_like 'success'
        end
      end
    end
  end
end