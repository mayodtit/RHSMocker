require 'spec_helper'

describe SendEmailToStakeholdersService do
  let!(:onboarding_group) { create(:onboarding_group, skip_automated_communications: true) }
  let!(:user) { create(:member, onboarding_group: onboarding_group) }

  it 'queues a delayed job to send the email' do
    expect{ described_class.new(user).call }.to change(Delayed::Job, :count).by(1)
  end
end
