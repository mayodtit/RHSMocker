require 'spec_helper'

describe WelcomeCallTask do

  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'foreign key of', :scheduled_phone_call
  end

  describe '#set_member' do
    let(:scheduled_phone_call) { build_stubbed :scheduled_phone_call }
    let(:welcome_call_task) { build_stubbed :welcome_call_task, scheduled_phone_call: scheduled_phone_call }

    it 'sets the member to the member being welcomed' do
      welcome_call_task.member = nil
      welcome_call_task.set_member
      welcome_call_task.member.should == scheduled_phone_call.user
    end
  end

  describe '#create_task!' do
    let(:pha) { build_stubbed :pha }
    let(:member) {build_stubbed :member}
    let(:scheduled_phone_call) { build_stubbed :scheduled_phone_call, owner: pha, assignor: pha }

    it 'should create a task with the correct attributes' do
      WelcomeCallTask.should_receive(:create!).with(title: 'Welcome Call', creator: Member.robot, due_at: scheduled_phone_call.scheduled_at, priority: 0, scheduled_phone_call: scheduled_phone_call, owner: scheduled_phone_call.owner, assignor: scheduled_phone_call.assignor)
      WelcomeCallTask.create_task! scheduled_phone_call
    end
  end

  describe '#set_priority_high'do
    let(:scheduled_phone_call) { build_stubbed :scheduled_phone_call }
    let(:welcome_call_task) { build_stubbed :welcome_call_task, scheduled_phone_call: scheduled_phone_call }

    it 'should set the priority high' do
      WelcomeCallTask.stub(:find).with(welcome_call_task.id) { welcome_call_task }
      WelcomeCallTask.set_priority_high(welcome_call_task.id)
      welcome_call_task.priority.should == 20
    end

    it 'should send a text message' do
      WelcomeCallTask.stub(:find).with(welcome_call_task.id) { welcome_call_task }
      TwilioModule.should_receive(:message).with welcome_call_task.owner.phone, "You have a Welcome Call Scheduled with #{welcome_call_task.member.full_name} in 15 minutes."
      WelcomeCallTask.set_priority_high(welcome_call_task.id)
    end
  end

  describe '#set_reminder!' do
    let(:delayed_job) { Delayed::Job.new }
    let(:scheduled_phone_call) { build_stubbed :scheduled_phone_call }
    let(:welcome_call_task) { build_stubbed :welcome_call_task, scheduled_phone_call: scheduled_phone_call }

    it 'should create a delayed job' do
      welcome_call_task.delayed_job.should == nil
      WelcomeCallTask.should_receive(:delay).with(run_at: 15.minutes.until(welcome_call_task.due_at)) do
        o = Object.new
        o.should_receive(:set_priority_high).with(welcome_call_task.id) { delayed_job }
        o
      end
      welcome_call_task.set_reminder
      welcome_call_task.delayed_job.should == delayed_job
    end
  end
end