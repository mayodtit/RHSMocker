require 'spec_helper'

describe Message do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_content
  it_has_a 'valid factory', :with_phone_call
  it_has_a 'valid factory', :with_scheduled_phone_call
  it_has_a 'valid factory', :with_phone_call_summary
  it_validates 'presence of', :user
  it_validates 'presence of', :consult
  it_validates 'foreign key of', :content
  it_validates 'foreign key of', :phone_call
  it_validates 'foreign key of', :scheduled_phone_call
  it_validates 'foreign key of', :phone_call_summary

  describe 'publish' do
    let(:message) { build_stubbed(:message) }

    it 'publishes that a message was created' do
      PubSub.should_receive(:publish).with(
        "/users/#{message.consult.initiator_id}/consults/#{message.consult_id}/messages/new",
        {id: message.id}
      )
      message.publish
    end
  end

  describe 'create_task' do
    let(:message) { build(:message) }

    before do
      message.stub(:scheduled_phone_call_id) { nil }
      message.stub(:phone_call_id) { nil }
    end

    context 'user message' do
      it 'creates a message task' do
        MessageTask.should_receive(:create_if_only_opened_for_consult!).with(message.consult, message)
        message.create_task
      end
    end

    context 'is a phone call message' do
      it 'doesn\'t publish' do
        message.stub(:phone_call_id) { 1 }
        MessageTask.should_not_receive(:create_if_only_opened_for_consult!)
        message.create_task
      end
    end

    context 'is a scheduled phone call message' do
      it 'doesn\'t publish' do
        message.stub(:scheduled_phone_call_id) { 1 }
        MessageTask.should_not_receive(:create_if_only_opened_for_consult!)
        message.create_task
      end
    end
  end
end
