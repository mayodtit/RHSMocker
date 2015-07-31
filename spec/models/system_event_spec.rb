require 'spec_helper'

describe SystemEvent do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :scheduled
  it_has_a 'valid factory', :triggered
  it_has_a 'valid factory', :canceled
  it_validates 'presence of', :user
  it_validates 'presence of', :system_event_template
  it_validates 'presence of', :trigger_at

  describe 'state machine' do
    describe 'initial state' do
      it 'defaults to scheduled' do
        expect(described_class.new).to be_scheduled
      end
    end
  end
end
