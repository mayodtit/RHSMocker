require 'spec_helper'

describe SendMayoPilotInviteEmailService do
  let!(:provider) { create(:member) }
  let!(:onboarding_group) { create(:onboarding_group, mayo_pilot: true, provider: provider) }
  let!(:user) { create(:member, onboarding_group: onboarding_group) }

  it 'queues a Mails::MayoPilotInviteJob' do
    Mails::MayoPilotInviteJob.should_receive(:create).and_call_original
    expect{ described_class.new(user).call }.to change(Delayed::Job, :count).by(1)
  end
end
