require 'spec_helper'

describe NonProductionMailInterceptor, "delivery interception" do
  let(:inner_mail){ ActionMailer::Base.mail(to: "Neel@getbetter.com", from: "wuang@getbetter.com", subject: "Test")}
  let(:outer_mail){ ActionMailer::Base.mail(to: "Neel@getworse.com", from: "wuang@getbetter.com", subject: "Test")}

  def deliver_outer_mail
    outer_mail.deliver
  end

  def deliver_inner_mail
    inner_mail.deliver
  end

  it "mail to non-getbetter.com goes to inner mailbox" do
    deliver_outer_mail

    NonProductionMailInterceptor.stub(:deliver? => false)
    expect(outer_mail.subject).to eq('[To:Neel@getworse.com]Test')
    expect(outer_mail.to).to eq(["test@getbetter.com"])
  end

  it "mail to @getbetter.com still goes" do
    NonProductionMailInterceptor.stub(:deliver? => true)
    deliver_inner_mail
    # expect { deliver_mail }.to change(ActionMailer::Base.deliveries, :count)
    expect(inner_mail.subject).to eq('Test')
    expect(inner_mail.to).to eq(["Neel@getbetter.com"])
  end
end

describe NonProductionMailInterceptor, "#.deliver?" do
  it "is false for recipients like johnny@test.com" do
    message = mock(to: %w[johnny@test.com])
    NonProductionMailInterceptor.deliver?(message).should be_false
  end

  it "is true for other recipients" do
    message = mock(to: %w[wuang@getbetter.com])
    NonProductionMailInterceptor.deliver?(message).should be_true
  end

  it 'is true for testelf emails' do
    message = mock(to: %w[wuang@testelf.com])
    NonProductionMailInterceptor.deliver?(message).should be_true
  end
end
