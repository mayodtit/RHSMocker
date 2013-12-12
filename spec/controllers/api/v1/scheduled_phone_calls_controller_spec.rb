require 'spec_helper'

describe Api::V1::ScheduledPhoneCallsController do
  let(:scheduled_phone_call) { build_stubbed(:scheduled_phone_call) }
  let(:user) { scheduled_phone_call.user }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before do
      ScheduledPhoneCall.stub(scoped: [scheduled_phone_call])
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of scheduled_phone_calls' do
        do_request
        json = JSON.parse(response.body)
        json['scheduled_phone_calls'].to_json.should == [scheduled_phone_call.as_json].to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    let(:scheduled_phone_calls) { double('scheduled_phone_calls', find: scheduled_phone_call) }

    before do
      ScheduledPhoneCall.stub(scoped: scheduled_phone_calls)
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the scheduled_phone_call' do
        do_request
        json = JSON.parse(response.body, symbolize_names: true)
        json[:scheduled_phone_call].to_json.should == scheduled_phone_call.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, scheduled_phone_call: scheduled_phone_call.as_json
    end

    before do
      ScheduledPhoneCall.stub(create: scheduled_phone_call)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to create the record' do
        ScheduledPhoneCall.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the scheduled_phone_call' do
          do_request
          json = JSON.parse(response.body)
          json['scheduled_phone_call'].to_json.should == scheduled_phone_call.as_json.to_json
        end
      end

      context 'save fails' do
        before do
          scheduled_phone_call.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, scheduled_phone_call: attributes_for(:scheduled_phone_call)
    end

    let(:scheduled_phone_calls) { double('scheduled_phone_calls', find: scheduled_phone_call) }

    before do
      ScheduledPhoneCall.stub(scoped: scheduled_phone_calls)
      scheduled_phone_call.stub(:update_attributes)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to update the record' do
        scheduled_phone_call.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before do
          scheduled_phone_call.stub(update_attributes: true)
        end

        it_behaves_like 'success'
      end

      context 'update_attributes fails' do
        before do
          scheduled_phone_call.stub(update_attributes: false)
          scheduled_phone_call.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'DELETE destroy' do
    def do_request
      delete :destroy
    end

    let(:scheduled_phone_calls) { double('scheduled_phone_calls', find: scheduled_phone_call) }

    before do
      ScheduledPhoneCall.stub(scoped: scheduled_phone_calls)
      scheduled_phone_call.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        scheduled_phone_call.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before do
          scheduled_phone_call.stub(destroy: true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before do
          scheduled_phone_call.stub(destroy: false)
          scheduled_phone_call.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
