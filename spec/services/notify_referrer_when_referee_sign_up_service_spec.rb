require 'spec_helper'

describe NotifyReferrerWhenRefereeSignUpService do
  let( :referrer ) { create(:member, :premium) }
  let( :referee ) { create(:member)}

  describe '#call' do
    it 'should send the notification email via delayed job' do
      Mails::NotifyReferrerOfSignUpJob.should_receive(:create).and_call_original
      expect{ described_class.new( referrer: referrer, referee: referee ).call }.to change(Delayed::Job, :count).by(1)
    end
  end
end