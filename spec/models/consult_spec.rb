require 'spec_helper'

describe Consult do
  it_has_a 'valid factory'
  it_validates 'presence of', :initiator
  it_validates 'presence of', :subject
  it_validates 'presence of', :state
  it_validates 'presence of', :title
  it_validates 'foreign key of', :symptom

  describe '#create_task' do
    let(:consult) { build_stubbed(:consult) }

    context 'messages is empty' do
      before do
        consult.stub(:messages) do
          o = Object.new
          o.stub(:empty?) { true }
          o
        end
      end

      it 'creates a message task' do
        Task.should_receive(:create_unique_open_message_for_consult!).with(consult)
        consult.create_task
      end
    end

    context 'messages is not empty' do
      before do
        consult.stub(:messages) do
          o = Object.new
          o.stub(:empty?) { false }
          o
        end
      end

      it 'creates a message task' do
        Task.should_not_receive(:create_unique_open_message_for_consult!)
        consult.create_task
      end
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
