require 'spec_helper'

describe RemoteEvent do
  describe 'factory' do
    let(:remote_event) { build(:remote_event) }

    it 'builds a valid object' do
      remote_event.should be_valid
      remote_event.save.should be_true
      remote_event.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires data' do
      build_stubbed(:remote_event, data: nil).should_not be_valid
    end
  end
end
