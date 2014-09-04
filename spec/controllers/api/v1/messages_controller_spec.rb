require 'spec_helper'

describe Api::V1::MessagesController do
  describe '#needs_off_hours_response' do
    let!(:member) { create(:member, :premium) }
    let(:consult) { member.master_consult }

    before do
      controller.stub(current_user: member,
                      consult: consult)
      controller.instance_variable_set('@consult', consult)
      Role.stub_chain(:pha, :on_call?).and_return(false)
      Timecop.freeze(Time.new(2014, 8, 29, 12, 0, 0, '-07:00'))
    end

    after do
      Timecop.return
    end

    def send_method
      controller.send(:needs_off_hours_response?)
    end

    it 'returns true under default conditions' do
      expect(send_method).to be_true
    end

    it 'returns false if PHAs are on call' do
      Role.stub_chain(:pha, :on_call?).and_return(true)
      expect(send_method).to be_false
    end

    it 'returns false if the current_user is not the consult initiator' do
      controller.stub(current_user: member.pha)
      expect(send_method).to be_false
    end

    it 'returns false if the current_user device version is >= 1.3.0' do
      member.stub(device_app_version: '1.3.0')
      expect(send_method).to be_false
    end

    it 'returns false if the consult already has an out of office message since off_hours_start' do
      consult.messages.create(user: Member.robot,
                              text: 'off hours message',
                              off_hours: true,
                              system: true)
      controller.stub(off_hours_start: Time.now - 1.second)
      expect(send_method).to be_false
    end
  end

  describe '#off_hours_start' do
    def send_method
      controller.send(:off_hours_start)
    end

    after do
      Timecop.return
    end

    context 'on a Saturday' do
      before do
        Timecop.freeze(Time.new(2014, 8, 30, 12, 0, 0, '-07:00'))
      end

      it 'returns 17:00 Pacific on Friday' do
        expect(send_method).to eq(Time.new(2014, 8, 29, 17, 0, 0, '-07:00'))
      end
    end

    context 'on a Sunday' do
      before do
        Timecop.freeze(Time.new(2014, 8, 31, 12, 0, 0, '-07:00'))
      end

      it 'returns 17:00 Pacific on Friday' do
        expect(send_method).to eq(Time.new(2014, 8, 29, 17, 0, 0, '-07:00'))
      end
    end

    context 'on a weekday after 17:00 Pacific' do
      before do
        Timecop.freeze(Time.new(2014, 8, 27, 19, 0, 0, '-07:00'))
      end

      it 'returns 17:00 Pacific on the same day' do
        expect(send_method).to eq(Time.new(2014, 8, 27, 17, 0, 0, '-07:00'))
      end
    end

    context 'on a weekday before 9:00 Pacific' do
      before do
        Timecop.freeze(Time.new(2014, 8, 27, 7, 0, 0, '-07:00'))
      end

      it 'returns 17:00 Pacific on the day before' do
        expect(send_method).to eq(Time.new(2014, 8, 26, 17, 0, 0, '-07:00'))
      end
    end
  end
end
