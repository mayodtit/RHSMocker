require 'spec_helper'

describe ScheduledCommunication do
  before do
    Timecop.freeze(Time.new(2014, 7, 28, 0, 0, 0, '-07:00'))
  end

  after do
    Timecop.return
  end

  it_has_a 'valid factory'
  it_has_a 'valid factory', :scheduled
  it_has_a 'valid factory', :held
  it_has_a 'valid factory', :delivered
  it_has_a 'valid factory', :canceled
  it_has_a 'valid factory', :with_reference

  describe 'validations' do
    it_validates 'presence of', :recipient
    it_validates 'foreign key of', :sender
    it_validates 'foreign key of', :reference
    it_validates 'numericality of', :relative_days
    it_validates 'integer numericality of', :relative_days
    it 'validates presence of reference when reference_event is present' do
      sc = build_stubbed(:scheduled_communication, reference_event: :free_trial_ends_at)
      expect(sc).to_not be_valid
      expect(sc.errors[:reference]).to include("can't be blank")
    end
  end

  context 'with a reference' do
    let(:sc) { build_stubbed(:scheduled_communication, reference: build_stubbed(:member)) }

    it 'validates presence of reference_event' do
      expect(sc).to_not be_valid
      expect(sc.errors[:reference_event]).to include("can't be blank")
    end

    it 'validates inclusion of reference_event' do
      expect(sc).to_not be_valid
      expect(sc.errors[:reference_event]).to include("is not included in the list")
    end

    it 'validates presence of relative_days' do
      expect(sc).to_not be_valid
      expect(sc.errors[:relative_days]).to include("can't be blank")
    end
  end

  describe '#update_publish_at_from_calculation!' do
    let(:new_free_trial_ends_at) { Time.now + 10.days }

    before do
      scheduled_communication.reference.update_attribute(:free_trial_ends_at, new_free_trial_ends_at)
    end

    context 'state is canceled' do
      let(:scheduled_communication) { create(:scheduled_communication, :with_reference, :canceled) }
      let(:publish_at) { scheduled_communication.publish_at }

      it 'does not change publish_at' do
        scheduled_communication.update_publish_at_from_calculation!
        expect(scheduled_communication.reload.publish_at).to eq(publish_at)
      end
    end

    context 'state is delivered' do
      let(:scheduled_communication) { create(:scheduled_communication, :with_reference, :delivered) }
      let(:publish_at) { scheduled_communication.publish_at }

      it 'does not change publish_at' do
        scheduled_communication.update_publish_at_from_calculation!
        expect(scheduled_communication.reload.publish_at).to eq(publish_at)
      end
    end

    context 'state is failed' do
      let(:scheduled_communication) { create(:scheduled_communication, :with_reference, :failed) }
      let(:publish_at) { scheduled_communication.publish_at }

      it 'does not change publish_at' do
        scheduled_communication.update_publish_at_from_calculation!
        expect(scheduled_communication.reload.publish_at).to eq(publish_at)
      end
    end

    context 'state is scheduled' do
      let(:scheduled_communication) { create(:scheduled_communication, :with_reference, :scheduled) }
      let(:publish_at) { scheduled_communication.publish_at }

      context 'new publish_at is in the past' do
        let(:new_free_trial_ends_at) { Time.new(2014, 7, 23, 17, 0, 0, '-07:00') }

        it 'cancels the scheduled communication' do
          scheduled_communication.update_publish_at_from_calculation!
          expect(scheduled_communication.reload.canceled?).to be_true
        end

        it 'updates publish_at' do
          scheduled_communication.update_publish_at_from_calculation!
          expect(scheduled_communication.reload.publish_at).to eq(Time.new(2014, 7, 23, ON_CALL_START_HOUR, 0, 0, '-07:00'))
        end
      end

      context 'new publish_at is in the future' do
        let(:new_free_trial_ends_at) { Time.new(2014, 7, 29, 17, 0, 0, '-07:00') }

        it 'updates publish_at' do
          scheduled_communication.update_publish_at_from_calculation!
          expect(scheduled_communication.reload.publish_at).to eq(Time.new(2014, 7, 29, ON_CALL_START_HOUR, 0, 0, '-07:00'))
        end
      end
    end

    context 'state is held' do
      let(:scheduled_communication) { create(:scheduled_communication, :with_reference, :held) }
      let(:publish_at) { scheduled_communication.publish_at }

      context 'new publish_at is in the past' do
        let(:new_free_trial_ends_at) { Time.new(2014, 7, 23, 17, 0, 0, '-07:00') }

        it 'cancels the scheduled communication' do
          scheduled_communication.update_publish_at_from_calculation!
          expect(scheduled_communication.reload.canceled?).to be_true
        end

        it 'updates publish_at' do
          scheduled_communication.update_publish_at_from_calculation!
          expect(scheduled_communication.reload.publish_at).to eq(Time.new(2014, 7, 23, ON_CALL_START_HOUR, 0, 0, '-07:00'))
        end
      end

      context 'new publish_at is in the future' do
        let(:new_free_trial_ends_at) { Time.new(2014, 7, 29, 17, 0, 0, '-07:00') }

        it 'updates publish_at' do
          scheduled_communication.update_publish_at_from_calculation!
          expect(scheduled_communication.reload.publish_at).to eq(Time.new(2014, 7, 29, ON_CALL_START_HOUR, 0, 0, '-07:00'))
        end
      end
    end
  end

  describe 'states' do
    describe 'scheduled' do
      let(:message) { build_stubbed(:scheduled_message, :scheduled) }

      it 'validates publish_at' do
        expect(message).to be_valid
        message.publish_at = nil
        expect(message).to_not be_valid
        expect(message.errors[:publish_at]).to include("can't be blank")
      end

      it 'validates delivered_at is nil' do
        expect(message).to be_valid
        message.delivered_at = Time.now
        expect(message).to_not be_valid
        expect(message.errors[:delivered_at]).to include('must be nil')
      end
    end

    describe 'delivered' do
      let(:message) { build_stubbed(:scheduled_message, :delivered) }

      it 'validates delivered_at' do
        expect(message).to be_valid
        message.delivered_at = nil
        expect(message).to_not be_valid
        expect(message.errors[:delivered_at]).to include("can't be blank")
      end
    end
  end
end
