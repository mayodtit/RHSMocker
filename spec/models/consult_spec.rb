require 'spec_helper'

describe Consult do
  it_has_a 'valid factory'
  it_validates 'presence of', :initiator
  it_validates 'presence of', :subject
  it_validates 'presence of', :state
  it_validates 'presence of', :title
  it_validates 'foreign key of', :symptom

  describe '#publish' do
    let(:consult) { build_stubbed(:consult) }

    it 'publishes a notification' do
      PubSub.should_receive(:publish).with(
          "/consults/empty/new",
          {id: consult.id}
        )
      consult.publish
    end
  end

  describe 'state machine' do
    describe 'states' do
      it 'sets the initial state to :open' do
        expect(described_class.new.state?(:open)).to be_true
      end
    end

    describe 'events' do
      describe ':close' do
        let(:consult) { build(:consult) }

        it 'changes :open to :closed' do
          expect(consult.state?(:open)).to be_true
          expect(consult.close).to be_true
          expect(consult.state?(:closed)).to be_true
        end
      end
    end
  end
end
