require 'spec_helper'

describe Api::V1::MessagesController do
  let(:message) { build_stubbed(:message) }
  let(:encounter) { message.encounter }
  let(:user) { message.user }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
    Encounter.stub(:find => encounter)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      encounter.stub(:messages => [message])
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of messages' do
        do_request
        json = JSON.parse(response.body)
        json['messages'].to_json.should == [message.as_json].to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    let(:messages) { double('messages', :find => message) }

    before(:each) do
      encounter.stub(:messages => messages)
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the encounter' do
        do_request
        json = JSON.parse(response.body)
        json['message'].to_json.should == message.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, message: message.as_json
    end

    let(:messages) { double('messages', :create => message) }

    before(:each) do
      encounter.stub(:messages => messages)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        messages.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the message' do
          do_request
          json = JSON.parse(response.body)
          json['message'].to_json.should == message.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          message.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
