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
          {id: entry.id}
      )
      entry.publish
    end
  end

end