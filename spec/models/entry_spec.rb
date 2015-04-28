require 'spec_helper'

describe Entry do
  it_has_a 'valid factory'
  it_validates 'presence of', :member
  it_validates 'presence of', :resource

  describe 'publish' do
    let(:entry) { build_stubbed(:entry) }

    it 'publishes that an entry was created' do
      PubSub.should_receive(:publish).with(
          "/members/#{entry.member.id}/timeline/entries/new",
          {id: entry.id},
          nil
      )
      entry.publish
    end
  end

  describe 'set_created_at' do
    let(:message) { create :message, created_at: 2.weeks.ago}
    let(:entry) { create :entry, resource: message}

    it 'should have the same created_at as the message' do
      expect(entry.created_at).to eq(message.created_at)
    end
  end

end