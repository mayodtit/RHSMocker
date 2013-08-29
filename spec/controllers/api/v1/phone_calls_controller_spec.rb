require 'spec_helper'

describe Api::V1::PhoneCallsController do
  let(:phone_call) { build_stubbed(:phone_call) }
  let(:consult) { phone_call.consult }
  let(:user) { consult.users.first }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
    Consult.stub(:find => consult)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      consult.stub(:phone_calls => [phone_call])
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of phone_calls' do
        do_request
        json = JSON.parse(response.body)
        json['phone_calls'].to_json.should == [phone_call.as_json].to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    let(:phone_calls) { double('phone_calls', :find => phone_call) }

    before(:each) do
      consult.stub(:phone_calls => phone_calls)
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the phone_call' do
        do_request
        json = JSON.parse(response.body, :symbolize_names => true)
        json[:phone_call].to_json.should == phone_call.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, phone_call: phone_call.as_json
    end

    before(:each) do
      PhoneCall.stub(:create => phone_call)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        PhoneCall.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the phone_call' do
          do_request
          json = JSON.parse(response.body)
          json['phone_call'].to_json.should == phone_call.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          phone_call.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
