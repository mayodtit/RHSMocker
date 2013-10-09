require 'spec_helper'

describe Message do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :consult

  describe 'callbacks' do
    let(:message) { build(:message) }

    it 'creates a message status for consult users' do
      message.user.message_statuses.should be_empty
      message.save!
      message.reload.user.message_statuses.should_not be_empty
    end
  end

  describe '#image_url' do
    it 'should return nil for a message without an image' do
      build(:message).image_url.should be_nil
    end
  end
end
