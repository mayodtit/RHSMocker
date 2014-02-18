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
