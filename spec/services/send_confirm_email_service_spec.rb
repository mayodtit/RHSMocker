require 'spec_helper'

describe SendConfirmEmailService do
  let!(:user) { create(:member, email_confirmed: false) }

  it 'queues a delayed job to send the email' do
    expect{ described_class.new(user).call }.to change(Delayed::Job, :count).by(1)
  end
end
