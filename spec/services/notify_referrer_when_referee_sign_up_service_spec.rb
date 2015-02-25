require 'spec_helper'

describe NotifyReferrerWhenRefereeSignUpService do
  let(:referrer) { create(:member)}
  let( :referral_code ) { create(:referral_code, user: referrer) }
  let( :member ) { create(:member)}
  describe '#call' do
    it 'should send the notification email via delayed job' do
      Mails::NotifyReferrerOfSignUpJob.should_receive(:create).and_call_original
      expect{ described_class.new( referral_code, member ).call }.to change(Delayed::Job, :count).by(1)
    end
  end
end
