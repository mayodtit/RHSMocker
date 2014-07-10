require 'spec_helper'

describe Consult do
  it_has_a 'valid factory'
  it_validates 'presence of', :initiator
  it_validates 'presence of', :subject
  it_validates 'presence of', :state
  it_validates 'presence of', :title
  it_validates 'foreign key of', :symptom
  it_validates 'inclusion of', :master

  it 'validates uniqueness of active per initiator' do
    current_consult = create(:consult, master: true)
    new_consult = build_stubbed(:consult, initiator: current_consult.initiator,
                                          master: true)
    expect(new_consult).to_not be_valid
    expect(new_consult.errors[:master]).to include("has already been taken")
  end

  describe 'callbacks' do
    describe '#send_initial_message' do
      let!(:pha) { create(:pha).tap{|p| p.create_pha_profile} }
      let!(:member) { create(:member, :premium, pha: pha, signed_up_at: Time.now) }
      let(:consult) { create(:consult, initiator: member) }

      it 'creates an initial message' do
        expect(consult.messages.count).to eq(1)
        expect(consult.messages.first.text).to eq(Consult::WELCOME_MESSAGE_TEXT)
      end

      it 'does not attach a message if there is already a message' do
        c = create(:consult, initiator: member, messages_attributes: [{user: member, text: 'hello world'}])
        expect(c.messages.count).to eq(1)
        expect(c.messages.first.text).to eq('hello world')
      end

      it 'does not attach a message if consult initiator is not signed up' do
        member.stub(signed_up?: false)
        expect(consult.messages.count).to eq(0)
      end

      it 'does not attach a message if the member is not assigned a pha' do
        member.update_attributes(pha_id: nil)
        expect(consult.messages.count).to eq(0)
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

  describe 'message associations' do
    let!(:consult) { create(:consult) }
    let!(:old_message) { create(:message, consult: consult, created_at: 2.days.ago) }
    let!(:new_message) { create(:message, consult: consult) }
    let!(:note) { create(:message, consult: consult, created_at: 1.day.ago, note: true) }

    describe '#messages' do
      it 'only returns messages that have note set to false' do
        consult.reload.messages.include?(old_message).should be_true
        consult.messages.include?(new_message).should be_true
        consult.messages.include?(note).should be_false
      end

      it 'returns messages ordered by created at' do
        consult.reload.messages.should == [old_message, new_message]
      end
    end

    describe '#messages_and_notes' do
      it 'returns all messages' do
        consult.messages_and_notes.include?(old_message).should be_true
        consult.messages_and_notes.include?(new_message).should be_true
        consult.messages_and_notes.include?(note).should be_true
      end

      it 'returns messages ordered by created at' do
        consult.messages_and_notes.should == [old_message, note, new_message]
      end
    end
  end
end
