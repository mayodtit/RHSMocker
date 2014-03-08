require 'spec_helper'

describe Api::V1::MessagesController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:message) { build_stubbed(:message) }
  let(:consult) { message.consult }

  before do
    controller.stub(current_ability: ability)
    Consult.stub(find: consult)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    before do
      consult.stub(messages: [message],
                   users: [message.user])
    end


    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of messages' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:messages].to_json).to eq([message].serializer.as_json.to_json)
      end
    end
  end

  describe 'POST create' do
    def do_request(params={text: 'text'})
      post :create, message: params
    end

    let(:messages) { double('messages', create: message) }

    before do
      consult.stub(messages: messages)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      context 'save fails' do
        before do
          message.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end

      context 'send robot response is true' do
        before do
          controller.stub(:send_robot_response?) { true }
        end

        it 'attempts to create the record' do
          controller.should_receive(:send_robot_response!).and_call_original
          messages.should_receive(:create).twice
          do_request
        end

        context 'save succeeds' do
          it_behaves_like 'success'

          it 'returns the message' do
            do_request
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
          end
        end
      end

      context 'send robot response is false' do
        before do
          controller.stub(:send_robot_response?) { false }
        end

        it 'attempts to create the record' do
          messages.should_not_receive(:send_robot_response!)
          messages.should_receive(:create).once
          do_request
        end

        context 'save succeeds' do
          it_behaves_like 'success'

          it 'returns the message' do
            do_request
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
          end
        end
      end
    end
  end
end
