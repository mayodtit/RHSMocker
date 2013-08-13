require 'spec_helper'

describe Message do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :encounter
  it_validates 'presence of', :text

  describe 'callbacks' do
    let(:message) { build(:message) }

    it 'creates a message status for encounter users' do
      message.user.message_statuses.should be_empty
      message.save!
      message.reload.user.message_statuses.should_not be_empty
    end
  end
end
