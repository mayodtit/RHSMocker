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

    before do
      message.stub(:scheduled_phone_call_id) { nil }
      message.stub(:phone_call_id) { nil }
    end

    context 'on create' do
      before do
        message.stub(:id_changed?) { true }
      end

      context 'user message' do
        it 'publishes that a message was created' do
          PubSub.should_receive(:publish).with(
            "/users/#{message.consult.initiator_id}/consults/#{message.consult_id}/messages/new",
            {id: message.id}
          )
          PubSub.should_receive(:publish).with(
            "/messages/new",
            {id: message.id}
          )
          message.publish
        end

        context 'unread by cp' do
          before do
            message.stub(:unread_by_cp?) { true }
          end

          it 'should send an email' do
            UserMailer.should_receive(:delay) do
              o = Object.new
              o.should_receive(:notify_phas_of_message)
              o
            end
            message.publish
          end
        end

        context 'read by cp' do
          before do
            message.stub(:unread_by_cp?) { false }
          end

          it 'should send an email' do
            UserMailer.should_not_receive(:delay)
            message.publish
          end
        end
      end

      context 'is a phone call message' do
        it 'doesn\'t publish' do
          message.stub(:phone_call_id) { 1 }
          PubSub.should_not_receive(:publish)
          UserMailer.should_not_receive(:delay)
          message.publish
        end
      end

      context 'is a scheduled phone call message' do
        it 'doesn\'t publish' do
          message.stub(:scheduled_phone_call_id) { 1 }
          PubSub.should_not_receive(:publish)
          UserMailer.should_not_receive(:delay)
          message.publish
        end
      end
    end

    context 'on save' do
      before do
        message.stub(:id_changed?) { false }
      end

      context 'read status changed' do
        before do
          message.stub(:unread_by_cp_changed?) { true }
        end

        it 'publishes' do
          PubSub.should_receive(:publish).with(
            "/messages/update/read",
            {id: message.id}
          )
          message.publish
        end
      end

      context 'read status didn\'t change' do
        before do
          message.stub(:unread_by_cp_changed?) { false }
        end

        it 'doesn\'t publish' do
          PubSub.should_not_receive(:publish)
        end
      end
    end
  end

  describe 'initialization of unread_by_cp' do
    let(:message) { build(:message) }

    it 'calls set_unread_by_cp' do
      message.should_receive(:set_unread_by_cp)
      message.valid?
    end

    context 'unread_by_cp is false' do
      it 'is kept false' do
        message.unread_by_cp = false
        message.valid?
        message.unread_by_cp.should be_false
      end
    end

    context 'unread_by_cp is true' do
      it 'is kept true' do
        message.unread_by_cp = true
        message.valid?
        message.unread_by_cp.should be_true
      end
    end

    context 'unread_by_cp is nil' do
      before do
        message.unread_by_cp = nil
        message.stub(:scheduled_phone_call_id) { nil }
        message.stub(:phone_call_id) { nil }
      end

      context 'is a phone call message' do
        it 'is set to true' do
          message.stub(:phone_call_id) { 1 }
          message.valid?
          message.unread_by_cp.should be_false
        end
      end

      context 'is a scheduled phone call message' do
        it 'is set to true' do
          message.stub(:scheduled_phone_call_id) { 1 }
          message.valid?
          message.unread_by_cp.should be_false
        end
      end

      it 'otherwise set to false' do
        message.valid?
        message.unread_by_cp.should be_true
      end
    end
  end
end
