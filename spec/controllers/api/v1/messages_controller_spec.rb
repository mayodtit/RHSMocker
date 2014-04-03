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
    before do
      consult.stub(messages: [message])
      consult.stub_chain(:users, :to_a, :uniq).and_return([message.user])
    end

    context 'current consult for user' do
      def do_request
        get :index, consult_id: 'current'
      end

      before do
        user.stub(master_consult: consult)
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

    context 'with consult_id' do
      def do_request
        get :index
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
