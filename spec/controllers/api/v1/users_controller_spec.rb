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
end
