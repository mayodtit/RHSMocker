require 'spec_helper'

describe MissedCallTask do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :phone_call_id
    it_validates 'foreign key of', :phone_call
  end

  describe '#set_member' do
    let(:phone_call) { build_stubbed :phone_call }
    let(:missed_call_task) { build_stubbed :missed_call_task, phone_call: phone_call }

    it 'sets the member to the consult initiator' do
      missed_call_task.member = nil
      missed_call_task.set_member
      missed_call_task.member.should == phone_call.user
    end
  end
end
