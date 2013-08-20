require 'spec_helper'

describe Api::V1::UserConditionsController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:user_condition) { build_stubbed(:user_condition, :user => user) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      user.stub(:user_conditions => [user_condition])
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of user diseases' do
        do_request
        json = JSON.parse(response.body)
        json['user_conditions'].to_json.should == [user_condition.as_json].to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    let(:user_conditions) { double('user_conditions', :find => user_condition) }

    before(:each) do
      user.stub(:user_conditions => user_conditions)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the user diseases' do
        do_request
        json = JSON.parse(response.body)
        json['user_condition'].to_json.should == user_condition.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, user_condition: user_condition.as_json
    end

    let(:user_conditions) { double('user_conditions', :create => user_condition) }

    before(:each) do
      user.stub(:user_conditions => user_conditions)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        user_conditions.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the user disease' do
          do_request
          json = JSON.parse(response.body)
          json['user_condition'].to_json.should == user_condition.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          user_condition.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update
    end

    let(:user_conditions) { double('user_conditions', :find => user_condition) }

    before(:each) do
      user.stub(:user_conditions => user_conditions)
      user_condition.stub(:update_attributes)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to update the record' do
        user_condition.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before(:each) do
          user_condition.stub(:update_attributes => true)
        end

        it_behaves_like 'success'
      end

      context 'update_attributes fails' do
        before(:each) do
          user_condition.stub(:update_attributes => false)
          user_condition.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'DELETE destroy' do
    def do_request
      delete :destroy
    end

    let(:user_conditions) { double('user_conditions', :find => user_condition) }

    before(:each) do
      user.stub(:user_conditions => user_conditions)
      user_condition.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        user_condition.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before(:each) do
          user_condition.stub(:destroy => true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before(:each) do
          user_condition.stub(:destroy => false)
          user_condition.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
