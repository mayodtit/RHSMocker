require 'spec_helper'

describe Api::V1::SubscriptionsController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:subscription) { build_stubbed(:subscription, :user => user) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      user.stub(:subscriptions => [subscription])
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of subscriptions' do
        do_request
        json = JSON.parse(response.body)
        json['subscriptions'].to_json.should == [subscription].active_model_serializer_instance.as_json.to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    let(:subscriptions) { double('subscriptions', :find => subscription) }

    before(:each) do
      user.stub(:subscriptions => subscriptions)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the subscriptions' do
        do_request
        json = JSON.parse(response.body)
        json['subscription'].to_json.should == subscription.active_model_serializer_instance.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, subscription: subscription.as_json
    end

    let(:subscriptions) { double('subscriptions', :create => subscription) }

    before(:each) do
      user.stub(:subscriptions => subscriptions)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        subscriptions.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the subscription' do
          do_request
          json = JSON.parse(response.body)
          json['subscription'].to_json.should == subscription.active_model_serializer_instance.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          subscription.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update
    end

    let(:subscriptions) { double('subscriptions', :find => subscription) }

    before(:each) do
      user.stub(:subscriptions => subscriptions)
      subscription.stub(:update_attributes)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to update the record' do
        subscription.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before(:each) do
          subscription.stub(:update_attributes => true)
        end

        it_behaves_like 'success'
      end

      context 'update_attributes fails' do
        before(:each) do
          subscription.stub(:update_attributes => false)
          subscription.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'DELETE destroy' do
    def do_request
      delete :destroy
    end

    let(:subscriptions) { double('subscriptions', :find => subscription) }

    before(:each) do
      user.stub(:subscriptions => subscriptions)
      subscription.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        subscription.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before(:each) do
          subscription.stub(:destroy => true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before(:each) do
          subscription.stub(:destroy => false)
          subscription.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
