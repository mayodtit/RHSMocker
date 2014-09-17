require 'spec_helper'

describe ScheduledPhoneCallObserver do
  describe '#after_save' do
    context 'during booking' do
      let!(:spc) { create(:scheduled_phone_call, :assigned) }
      let!(:member) { create(:member, :premium) }
      let!(:service_type) do
        create(:service_type, name: 'member onboarding', bucket: 'engagement')
      end

      def do_request
        spc.update_attributes!(state_event: :book,
                               booker: member,
                               user: member)
      end

      context 'with a scheduled inbound message during booking' do
        let(:scheduled) { create(:scheduled_message, :scheduled, recipient: member) }

        it 'holds scheduled communications for the user' do
          expect(scheduled.scheduled?).to be_true
          do_request
          expect(scheduled.reload.scheduled?).to be_false
          expect(scheduled.held?).to be_true
        end
      end

      it 'creates an engagement MemberTask' do
        expect{ do_request }.to change(MemberTask, :count).by(1)
      end
    end
  end
end
