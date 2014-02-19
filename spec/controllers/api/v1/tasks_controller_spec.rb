require 'spec_helper'

describe Api::V1::TasksController do
  let(:user) do
    member = build_stubbed :member
    member.add_role :nurse
    member
  end

  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'indexes unread messages' do
        messages = [build(:message)]
        controller.should_receive(:unread_messages) { messages }

        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:tasks].to_json).to eq(messages.serializer.as_json.to_json)
      end
    end
  end

  describe '#unread_messages' do
    it 'returns unread messages that are not system messages' do
      Message.should_receive(:where).with(phone_call_id: nil, scheduled_phone_call_id: nil, unread_by_cp: true) do
        o = Object.new
        o.should_receive(:group).with('consult_id')
        o
      end

      controller.send(:unread_messages)
    end
  end
end