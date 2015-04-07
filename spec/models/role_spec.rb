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

      it 'doesn\'t accept calls before on call start hour' do
        time.stub(:wday) { 1 }
        time.stub(:hour) { ON_CALL_START_HOUR - 1 }
        role.should_not be_on_call
      end

      it 'doesn\'t accept calls after on call end hour' do
        time.stub(:wday) { 1 }
        time.stub(:hour) { ON_CALL_END_HOUR }
        role.should_not be_on_call
      end

      it 'accepts calls when PHAs are forced on call' do
        Metadata.stub(:force_phas_on_call?) { true }

        time.stub(:wday) { 6 }
        role.should be_on_call

        time.stub(:wday) { 0 }
        role.should be_on_call

        time.stub(:wday) { 1 }
        time.stub(:hour) { ON_CALL_START_HOUR - 1 }
        role.should be_on_call

        time.stub(:wday) { 1 }
        time.stub(:hour) { ON_CALL_END_HOUR }
        role.should be_on_call
      end
    end

    context 'nurse' do
      let(:role) { build :role, name: 'nurse' }

      it 'always returns true' do
        role.should be_on_call
      end
    end
  end

  context '#pha_stakeholders' do
    before do
      @pha_lead = Role.find_or_create_by_name :pha_lead
      Member.stub(:find_by_email)
    end

    it 'returns all leads' do
      leads = [build_stubbed(:pha_lead), build_stubbed(:pha_lead)]
      Role.should_receive(:pha_lead) do
        o = Object.new
        o.should_receive(:users) do
          o_o = Object.new
          o_o.should_receive(:members) { leads }
          o_o
        end
        o
      end
      Role.pha_stakeholders.should == leads
    end

    it 'returns geoff if he has an account' do
      geoff = build_stubbed :member
      Member.stub(:find_by_email).with('geoff@getbetter.com') { geoff }
      Role.pha_stakeholders.should == [geoff]
    end
  end
end
