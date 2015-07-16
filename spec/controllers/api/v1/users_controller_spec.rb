require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(current_ability: ability)
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    before do
      User.stub(find: user)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the user' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:user].to_json.should == user.serializer.as_json.to_json
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, user: attributes_for(:user)
    end

    before do
      User.stub(find: user)
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

        it 'returns the user' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          body[:user].to_json.should == user.serializer.as_json.to_json
        end
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
