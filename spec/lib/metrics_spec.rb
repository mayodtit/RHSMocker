describe Metrics do
  before do
    Timecop.freeze(Date.today.to_time)
    described_class.instance.reload!
  end

  after do
    Timecop.return
  end

  describe '#backfill_message_response_events' do
    def call_method
      described_class.instance.backfill_message_response_events
    end

    let(:tracker) { double(:mixpanel_tracker) }
    let(:pha) { create(:pha) }
    let(:user) { create(:member, :premium, pha: pha) }
    let(:consult) { user.master_consult }

    before do
      Mixpanel::Tracker.stub(new: tracker)
    end

    context 'one message, one response' do
      let!(:user_message) { create(:message, user: user, consult: consult, created_at: Time.now - 1.minute) }
      let!(:response_message) { create(:message, user: pha, consult: consult, created_at: Time.now) }
      let(:expected_properties) do
        {
          time: user_message.created_at.to_i,
          user_id: user.id,
          responder_id: pha.id,
          message_id: user_message.id,
          response_id: response_message.id,
          duration: 60,
          import_time: Time.now.to_i
        }
      end

      it 'tracks the event' do
        tracker.should_receive(:import).with(ENV['MIXPANEL_API_KEY'], user.id, 'Message Response', expected_properties).once
        expect(call_method[:imported_event_count]).to eq(1)
      end

      context 'during a dry run' do
        before do
          described_class.instance.configure(dry_run: true)
        end

        it "doesn't track the event, but it does see it" do
          tracker.should_not_receive(:import)
          expect(call_method[:imported_event_count]).to eq(1)
        end
      end
    end

    context 'two messages, one response' do
      let!(:first_user_message) { create(:message, user: user, consult: consult, created_at: Time.now - 1.minute) }
      let!(:second_user_message) { create(:message, user: user, consult: consult, created_at: Time.now - 30.seconds) }
      let!(:response_message) { create(:message, user: pha, consult: consult, created_at: Time.now) }
      let(:expected_properties) do
        {
          time: first_user_message.created_at.to_i,
          user_id: user.id,
          responder_id: pha.id,
          message_id: first_user_message.id,
          response_id: response_message.id,
          duration: 60,
          import_time: Time.now.to_i
        }
      end

      it 'tracks the first event' do
        tracker.should_receive(:import).with(ENV['MIXPANEL_API_KEY'], user.id, 'Message Response', expected_properties).once
        expect(call_method[:imported_event_count]).to eq(1)
      end
    end

    context 'one unanswered message' do
      let!(:user_message) { create(:message, user: user, consult: consult, created_at: Time.now - 1.minute) }

      it 'returns messages requiring a response to the console' do
        tracker.should_not_receive(:import)
        expect(call_method[:needs_response]).to eq([user_message])
      end
    end
  end
end
