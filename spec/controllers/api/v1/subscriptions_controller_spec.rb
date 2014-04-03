require 'spec_helper'

describe Api::V1::SubscriptionsController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:subscription) { build_stubbed(:subscription, :user => user) }

  before(:each) do
    controller.stub(:current_ability => ability)
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
      xit 'attempts to create the record' do
        subscriptions.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        # it_behaves_like 'success'

        xit 'returns the subscription' do
          do_request
          json = JSON.parse(response.body)
          json['subscription'].to_json.should == subscription.serializer.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          subscription.errors.add(:base, :invalid)
        end
      end
    end
  end
end
