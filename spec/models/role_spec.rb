require 'spec_helper'

describe Role do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'uniqueness of', :name, :resource_id, :resource_type

  describe '#on_call' do
    context 'pha' do
      let(:role) { build :role, name: 'pha' }
      let(:time) { Object.new }

      before do
        Time.stub(:now) do
          time.stub(:in_time_zone) do
            time
          end
          time
        end
      end

      it 'converts time to Pacific Time' do
        converted_time = Object.new
        time.should_receive('in_time_zone').with('Pacific Time (US & Canada)') { converted_time }
        converted_time.should_receive(:wday).twice { 1 }
        converted_time.should_receive(:hour).twice { 10 }

        role.should be_on_call
      end

      it 'forces phas off call if Metadata says so' do
        converted_time = Object.new
        time.should_receive('in_time_zone').with('Pacific Time (US & Canada)') { converted_time }
        converted_time.should_receive(:wday).twice { 1 }
        converted_time.should_receive(:hour).twice { 10 }
        Metadata.stub(:force_phas_off_call?) { true }
        role.should_not be_on_call
      end

      it 'doesn\'t accept calls on Saturday' do
        time.stub(:wday) { 6 }
        role.should_not be_on_call
      end

      it 'doesn\'t accept calls on Sunday' do
        time.stub(:wday) { 0 }
        role.should_not be_on_call
      end

      it 'doesn\'t accept calls before 9AM' do
        time.stub(:wday) { 1 }
        time.stub(:hour) { 7 }
        role.should_not be_on_call
      end

      it 'doesn\'t accept calls after 6PM' do
        time.stub(:wday) { 1 }
        time.stub(:hour) { 18 }
        role.should_not be_on_call
      end

    end

    context 'nurse' do
      let(:role) { build :role, name: 'nurse' }

      it 'always returns true' do
        role.should be_on_call
      end
    end
  end
end
