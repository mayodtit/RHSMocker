require 'spec_helper'

describe PhoneCall do
  it_has_a 'valid factory'

  before do
    @pha = Role.find_or_create_by_name!('pha')
    @pha_id = @pha.id
    @nurse = Role.find_or_create_by_name!('nurse')
    @nurse_id = @nurse.id
    PhoneCallTask.stub(:create_if_only_opened_for_consult!)
  end

  describe 'validations' do
    before do
      PhoneCall.any_instance.stub(:generate_identifier_token)
    end

    it_validates 'presence of', :identifier_token
    it_validates 'presence of', :twilio_conference_name
    it_validates 'uniqueness of', :identifier_token
    it_validates 'foreign key of', :to_role
    it_validates 'foreign key of', :merged_into_phone_call

    it 'validates the presence of to_role_id' do
      p = build_stubbed(:phone_call)
      p.outbound = false
      p.to_role_id = @pha_id
      p.should be_valid
      p.to_role_id = nil
      p.should_not be_valid
    end

    it 'doesn\'t validate the presence of to_role_id if outbound' do
      p = build_stubbed(:phone_call)
      p.outbound = true
      p.to_role_id = nil
      p.should be_valid
    end
  end

  describe 'phone numbers' do
    let(:phone_call) { build(:phone_call) }

    it_validates 'phone number format of', :origin_phone_number
    it_validates 'phone number format of', :destination_phone_number, true
  end

  describe '#origin_connected?' do
    it 'returns true when origin_status is connected' do
      phone_call = PhoneCall.new
      phone_call.origin_status = PhoneCall::CONNECTED_STATUS
      phone_call.should be_origin_connected
    end

    it 'returns false when origin_status is not connected' do
      phone_call = PhoneCall.new
      phone_call.origin_status = 'busy'
      phone_call.should_not be_origin_connected
    end
  end

  describe '#destination_connected?' do
    it 'returns true when destination_status is connected' do
      phone_call = PhoneCall.new
      phone_call.destination_status = PhoneCall::CONNECTED_STATUS
      phone_call.should be_destination_connected
    end

    it 'returns false when destination_status is not connected' do
      phone_call = PhoneCall.new
      phone_call.destination_status = 'busy'
      phone_call.should_not be_destination_connected
    end
  end

  describe '#cp_connected?' do
    let(:phone_call) { build :phone_call }

    context 'call is outbound' do
      before do
        phone_call.stub(:outbound?) { true }
      end

      context 'origin is connected' do
        before do
          phone_call.stub(:origin_connected?) { true }
        end

        it 'returns true' do
          phone_call.should be_cp_connected
        end
      end

      context 'origin is not connected' do
        before do
          phone_call.stub(:origin_connected?) { false }
        end

        it 'returns false' do
          phone_call.should_not be_cp_connected
        end
      end
    end

    context 'call is not outbound' do
      before do
        phone_call.stub(:outbound?) { false }
      end

      context 'origin is connected' do
        before do
          phone_call.stub(:destination_connected?) { true }
        end

        it 'returns true' do
          phone_call.should be_cp_connected
        end
      end

      context 'origin is not connected' do
        before do
          phone_call.stub(:destination_connected?) { false }
        end

        it 'returns false' do
          phone_call.should_not be_cp_connected
        end
      end
    end
  end

  describe '#member_connected?' do
    let(:phone_call) { build :phone_call }

    context 'call is outbound' do
      before do
        phone_call.stub(:outbound?) { true }
      end

      context 'origin is connected' do
        before do
          phone_call.stub(:destination_connected?) { true }
        end

        it 'returns true' do
          phone_call.should be_member_connected
        end
      end

      context 'origin is not connected' do
        before do
          phone_call.stub(:destination_connected?) { false }
        end

        it 'returns false' do
          phone_call.should_not be_member_connected
        end
      end
    end

    context 'call is not outbound' do
      before do
        phone_call.stub(:outbound?) { false }
      end

      context 'origin is connected' do
        before do
          phone_call.stub(:origin_connected?) { true }
        end

        it 'returns true' do
          phone_call.should be_member_connected
        end
      end

      context 'origin is not connected' do
        before do
          phone_call.stub(:origin_connected?) { false }
        end

        it 'returns false' do
          phone_call.should_not be_member_connected
        end
      end
    end
  end

  describe '#to_nurse?' do
    it 'returns true if the phone_call is to a nurse' do
      phone_call = build_stubbed(:phone_call, :to_role => Role.new(:name => :nurse))
      phone_call.should be_to_nurse
    end

    it 'returns false if the phone_call is not to a nurse' do
      phone_call = build_stubbed(:phone_call, :to_role => Role.new(:name => :pha))
      phone_call.should_not be_to_nurse
    end
  end

  describe '#to_pha?' do
    it 'returns true if the phone_call is to a pha' do
      phone_call = build_stubbed(:phone_call, :to_role => Role.new(:name => :pha))
      phone_call.should be_to_pha
    end

    it 'returns false if the phone_call is not to a pha' do
      phone_call = build_stubbed(:phone_call, :to_role => Role.new(:name => :nurse))
      phone_call.should_not be_to_pha
    end
  end

  describe '#in_progress?' do
    let(:phone_call) { build :phone_call }

    it 'true for unresolved' do
      phone_call.state = :unresolved
      phone_call.should be_in_progress
    end

    it 'true for unclaimed' do
      phone_call.state = :unclaimed
      phone_call.should be_in_progress
    end

    it 'true for dialing' do
      phone_call.state = :dialing
      phone_call.should be_in_progress
    end

    it 'true for connected' do
      phone_call.state = :connected
      phone_call.should be_in_progress
    end

    it 'true for disconnected' do
      phone_call.state = :disconnected
      phone_call.should be_in_progress
    end

    it 'false for missed' do
      phone_call.state = :missed
      phone_call.should_not be_in_progress
    end

    it 'false for ended' do
      phone_call.state = :ended
      phone_call.should_not be_in_progress
    end
  end

  describe '#accepting_calls_to_pha?' do
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

      PhoneCall.should be_accepting_calls_to_pha
    end

    it 'doesn\'t accept calls on Saturday' do
      time.stub(:wday) { 6 }
      PhoneCall.should_not be_accepting_calls_to_pha
    end

    it 'doesn\'t accept calls on Sunday' do
      time.stub(:wday) { 0 }
      PhoneCall.should_not be_accepting_calls_to_pha
    end

    it 'doesn\'t accept calls before 9AM' do
      time.stub(:wday) { 1 }
      time.stub(:hour) { 7 }
      PhoneCall.should_not be_accepting_calls_to_pha
    end

    it 'doesn\'t accept calls after 6PM' do
      time.stub(:wday) { 1 }
      time.stub(:hour) { 18 }
      PhoneCall.should_not be_accepting_calls_to_pha
    end
  end

  describe 'callbacks' do
    let(:phone_call) { build_stubbed(:phone_call, :identifier_token => nil) }

    describe '#generate_identifier_token' do
      before do
        SecureRandom.stub(:random_number).and_return(5, 5, 5, 10)
      end

      it 'generates an identifier token on validate' do
        phone_call.identifier_token.should be_nil
        phone_call.valid?
        phone_call.identifier_token.should_not be_nil
      end

      it 'generates a length 15 string' do
        phone_call.valid?
        phone_call.identifier_token.length.should == 15
      end

      it 'generates a unique number' do
        create(:phone_call, :identifier_token => nil)
        phone_call.valid?
        phone_call.identifier_token.to_i.should == 10
      end
    end

    describe '#prep_phone_numbers' do
      it 'is called before validation' do
        phone_call = PhoneCall.new
        phone_call.should_receive :prep_phone_numbers
        phone_call.valid?
      end

      it 'doesn\'t preps phone numbers that haven\'t changed' do
        phone_call = PhoneCall.new
        PhoneNumberUtil.should_not_receive :prep_phone_number_for_db
        phone_call.valid?
      end

      it 'doesn\'t preps phone numbers that haven\'t changed' do
        phone_call = PhoneCall.new
        phone_call.destination_phone_number = '(408)3913578'
        PhoneNumberUtil.should_receive(:prep_phone_number_for_db).with('(408)3913578')
        phone_call.valid?
      end
    end

    describe '#dial_if_outbound' do
      it 'is called after create' do
        phone_call = build(:phone_call)
        phone_call.should_receive :dial_if_outbound
        phone_call.save!
      end
    end

    describe '#transition_state' do
      let(:phone_call) { build(:phone_call) }

      it 'is called before validation' do
        phone_call = PhoneCall.new
        phone_call.should_receive :transition_state
        phone_call.valid?
      end

      shared_examples 'disconnect transition state' do
        context 'state is connected' do
          before do
            phone_call.state = 'connected'
          end

          it 'disconnects' do
            phone_call.should_receive(:disconnect)
            phone_call.valid?
          end
        end

        context 'state is not connected' do
          before do
            phone_call.state = 'unclaimed'
          end

          it 'doesn\'t disconnect' do
            phone_call.should_not_receive(:disconnect)
            phone_call.valid?
          end
        end
      end

      context 'origin is disconnected' do
        before do
          phone_call.stub(:origin_connected?) { false }
        end

        it_behaves_like 'disconnect transition state'
      end

      context 'destination is disconnected' do
        before do
          phone_call.stub(:destination_connected?) { false }
        end

        it_behaves_like 'disconnect transition state'
      end

      context 'neither parties are disconnected' do
        before do
          phone_call.stub(:origin_connected?) { true }
          phone_call.stub(:destination_connected?) { true }
        end

        context 'state is disconnected' do
          before do
            phone_call.state = 'disconnected'
          end

          it 'connects' do
            phone_call.should_receive(:connect)
            phone_call.valid?
          end
        end

        context 'state is dialing' do
          before do
            phone_call.state = 'dialing'
          end

          it 'connects' do
            phone_call.should_receive(:connect)
            phone_call.valid?
          end
        end

        context 'state is not dialing or disconnected' do
          before do
            phone_call.state = 'unclaimed'
          end

          it 'connects' do
            phone_call.should_not_receive(:connect)
            phone_call.valid?
          end
        end
      end
    end

    describe '#set_to_role' do
      context 'outbound call' do
        let(:phone_call) { build(:phone_call, outbound: true) }

        it 'does nothing if to_role_id is nil' do
          phone_call.to_role_id = nil
          phone_call.save!
          phone_call.reload.to_role_id.should be_nil
        end
      end

      context 'inbound call' do
        let(:phone_call) { build(:phone_call) }

        it 'does nothing if to_role_id is set on creation' do
          phone_call.to_role_id = @nurse_id
          phone_call.save!
          phone_call.reload.to_role_id.should == @nurse_id
        end

        it 'does to_role_id to the pha id if unset' do
          phone_call.to_role_id = nil
          phone_call.save!
          phone_call.reload.to_role_id.should == @pha_id
        end
      end
    end
  end

  describe '#dial_if_outbound' do
    let(:phone_call) { build(:phone_call) }

    it 'dials origin if outbound' do
      phone_call.stub(:outbound?) { true }
      phone_call.should_receive :dial_origin
      phone_call.dial_if_outbound
    end

    it 'doesn\'t dial origin if not outbound' do
      phone_call.stub(:outbound?) { false }
      phone_call.should_not_receive :dial_origin
      phone_call.dial_if_outbound
    end
  end

  describe 'dialing' do
    let(:dialer) { build(:pha) }
    let(:phone_call) { build(:phone_call) }
    let(:connect_url) { '/connect' }
    let(:status_url) { '/status' }
    let(:twilio_call) do
      o = Object.new
      o.stub(:sid) { '1' }
      o
    end

    before do
      PhoneCall.twilio.account.calls.stub(:create) { twilio_call }

      PhoneNumberUtil.stub(:format_for_dialing) do |number|
        "1#{number}"
      end

      URL_HELPERS.stub(:connect_origin_api_v1_phone_call_url).with(phone_call) { connect_url }
      URL_HELPERS.stub(:connect_destination_api_v1_phone_call_url).with(phone_call) { connect_url }
      URL_HELPERS.stub(:status_origin_api_v1_phone_call_url).with(phone_call) { status_url }
      URL_HELPERS.stub(:status_destination_api_v1_phone_call_url).with(phone_call) { status_url }

      phone_call.state = 'dialing'
    end

    describe '#dial_origin' do
      it 'dials the origin phone number via twilio' do
        PhoneCall.twilio.account.calls.should_receive(:create).with(
          from: "1#{Metadata.pha_phone_number}",
          to: "1#{phone_call.origin_phone_number}",
          url: connect_url,
          method: 'POST',
          status_callback: status_url,
          status_callback_method: 'POST'
        )

        phone_call.dial_origin(dialer)
      end

      it 'transitions to dialing' do
        phone_call.should_receive(:update_attributes!).with(state_event: :dial, origin_twilio_sid: '1', dialer: dialer)
        phone_call.dial_origin(dialer)
      end

      it 'sets the dialer to the one in phone call if not present' do
        phone_call.dialer = dialer
        phone_call.should_receive(:update_attributes!).with(state_event: :dial, origin_twilio_sid: '1', dialer: dialer)
        phone_call.dial_origin
      end
    end

    describe '#dial_destination' do
      it 'dials the destination phone number via twilio' do
        PhoneCall.twilio.account.calls.should_receive(:create).with(
          from: "1#{Metadata.pha_phone_number}",
          to: "1#{phone_call.destination_phone_number}",
          url: connect_url,
          method: 'POST',
          status_callback: status_url,
          status_callback_method: 'POST'
        )

        phone_call.dial_destination(dialer)
      end

      it 'transitions to dialing' do
        phone_call.should_receive(:update_attributes!).with(state_event: :dial, destination_twilio_sid: '1', dialer: dialer)
        phone_call.dial_destination(dialer)
      end

      it 'sets the dialer to the one in phone call if not present' do
        phone_call.dialer = dialer
        phone_call.should_receive(:update_attributes!).with(state_event: :dial, destination_twilio_sid: '1', dialer: dialer)
        phone_call.dial_destination
      end

      it 'doesn\'t transition to dialing if it\'s to nurseline' do
        phone_call.stub(:to_role) { build(:role, name: 'nurse') }
        phone_call.should_not_receive(:update_attributes!)
        phone_call.dial_destination(dialer)
      end
    end
  end

  describe '#resolve' do
    let(:twilio_sid) { 'CAf7546453bca08b52f3e84ee102d82262' }
    let(:phone_call) { build(:phone_call, to_role: build_stubbed(:role, name: 'nurse')) }
    let(:phone_number) { '+14083913578' }

    context 'phone number is not valid caller id' do
      before do
        PhoneNumberUtil.stub(:is_valid_caller_id) { false }
      end

      it 'creates a phone call with nil origin phone number' do
        PhoneCall.should_receive(:create).with(
          origin_phone_number: nil,
          destination_phone_number: Metadata.pha_phone_number,
          to_role: @pha,
          state_event: :resolve,
          origin_twilio_sid: twilio_sid,
          origin_status: PhoneCall::CONNECTED_STATUS
        )

        PhoneCall.resolve(phone_number, twilio_sid)
      end
    end

    context 'phone number is valid caller id' do
      let(:db_phone_number) { PhoneNumberUtil::prep_phone_number_for_db(phone_number) }

      before do
        PhoneNumberUtil.stub(:is_valid_caller_id) { true }
      end

      context 'unresolved phone call exists' do
        before do
          PhoneCall.stub(:where).with(state: :unresolved, origin_phone_number: db_phone_number) do
            o = Object.new
            o.stub(:first).with(order: 'id desc', limit: 1) do
              phone_call
            end
            o
          end
        end

        it 'resolves the phone call' do
          phone_call.should_receive(:update_attributes).with(state_event: :resolve, origin_twilio_sid: twilio_sid, origin_status: PhoneCall::CONNECTED_STATUS)
          PhoneCall.resolve(phone_number, twilio_sid).should == phone_call
        end

        it 'does not create a phone call' do
          PhoneCall.should_not_receive(:create)
          PhoneCall.resolve(phone_number, twilio_sid)
        end
      end

      context 'unresolved phone call does not exist' do
        before do
          PhoneCall.stub(:where).with(state: :unresolved, origin_phone_number: db_phone_number) do
            o = Object.new
            o.stub(:first).with(order: 'id desc', limit: 1) do
              nil
            end
            o
          end
        end

        context 'member with phone exists' do
          let(:member) { build(:member) }
          before do
            Member.stub(:find_by_phone).with(db_phone_number) { member }
          end

          it 'creates a PhoneCall' do
            PhoneCall.should_receive(:create).with(
              user: member,
              origin_phone_number: db_phone_number,
              destination_phone_number: Metadata.pha_phone_number,
              to_role: @pha,
              state_event: :resolve,
              origin_twilio_sid: twilio_sid,
              origin_status: PhoneCall::CONNECTED_STATUS
            ) { phone_call }

            PhoneCall.resolve(phone_number, twilio_sid).should == phone_call
          end
        end

        context 'member with phone does not exist' do
          before do
            Member.stub(:find_by_phone).with(db_phone_number) { nil }
          end

          it 'creates a PhoneCall without a member' do
            PhoneCall.should_receive(:create).with(
              origin_phone_number: db_phone_number,
              destination_phone_number: Metadata.pha_phone_number,
              to_role: @pha,
              state_event: :resolve,
              origin_twilio_sid: twilio_sid,
              origin_status: PhoneCall::CONNECTED_STATUS
            ) { phone_call }

            PhoneCall.resolve(phone_number, twilio_sid).should == phone_call
          end
        end
      end
    end
  end

  describe '#hang_up' do
    let(:phone_call) { build :phone_call }

    shared_examples 'completes call' do
      it 'completes the call' do
        PhoneCall.twilio.account.calls.should_receive(:get).with('FAKE_SID') do
          o = Object.new
          o.should_receive(:update).with(status: 'completed')
          o
        end
        phone_call.hang_up
      end
    end

    shared_examples 'does nothing' do
      it 'does nothing' do
        PhoneCall.twilio.account.calls.should_not_receive(:get)
        phone_call.hang_up
      end
    end

    context 'origin has twilio sid' do
      before do
        phone_call.stub(:origin_twilio_sid) { 'FAKE_SID' }
      end

      context 'origin is hcp' do
        before do
          phone_call.stub(:outbound?) { true }
        end

        it_behaves_like 'completes call'
      end

      context 'origin is member' do
        before do
          phone_call.stub(:outbound?) { false }
        end

        context 'call is transferred' do
          before do
            phone_call.stub(:transferred?) { true }
          end

          it_behaves_like 'does nothing'
        end

        context 'call is not transferred' do
          before do
            phone_call.stub(:transferred?) { false }
          end

          it_behaves_like 'completes call'
        end
      end
    end

    context 'destination has twilio sid' do
      before do
        phone_call.stub(:destination_twilio_sid) { 'FAKE_SID' }
      end

      context 'destination is hcp' do
        before do
          phone_call.stub(:outbound?) { false }
        end

        it_behaves_like 'completes call'
      end

      context 'destination is member' do
        before do
          phone_call.stub(:outbound?) { true }
        end

        context 'call is transferred' do
          before do
            phone_call.stub(:transferred?) { true }
          end

          it_behaves_like 'does nothing'
        end

        context 'call is not transferred' do
          before do
            phone_call.stub(:transferred?) { false }
          end

          it_behaves_like 'completes call'
        end
      end
    end

    context 'no sids' do
      it_behaves_like 'does nothing'
    end
  end

  describe '#transferred?' do
    let(:phone_call) { build :phone_call }

    it 'is true when transferred_to_phone_call_id is present' do
      phone_call.stub(:transferred_to_phone_call_id) { 1 }
      phone_call.should be_transferred
    end

    it 'is false when transferred_to_phone_call_id is not present' do
      phone_call.stub(:transferred_to_phone_call_id) { nil }
      phone_call.should_not be_transferred
    end
  end

  describe '#transfer!' do
    let(:phone_call) { build :phone_call }
    let(:nurseline_phone_call) { build :phone_call, to_role: @nurse }

    before do
      PhoneCall.stub(:create!) { nurseline_phone_call }
    end

    it 'creates a nurseline phone call and sets it as the transferred to call' do
      phone_call.origin_status = PhoneCall::CONNECTED_STATUS

      PhoneCall.should_receive(:create!).with(
        user: phone_call.user,
        origin_phone_number: phone_call.origin_phone_number,
        destination_phone_number: Metadata.nurse_phone_number,
        to_role: @nurse,
        origin_twilio_sid: phone_call.origin_twilio_sid,
        twilio_conference_name: phone_call.twilio_conference_name,
        origin_status: PhoneCall::CONNECTED_STATUS
      )

      phone_call.transfer!
      phone_call.transferred_to_phone_call.should == nurseline_phone_call
    end

    it 'dials the destination' do
      nurseline_phone_call.should_receive :dial_destination
      phone_call.transfer!
    end
  end

  describe '#merge_attributes!' do
    let(:phone_call) { build :phone_call }
    let(:other_phone_call) { build :phone_call }

    before do
      phone_call.stub :save!
    end

    it 'filters out specific attrs' do
      other_phone_call.stub(:attributes) do
        {
          user_id: 2,
          id: 2,
          destination_phone_number: '',
          merged_into_phone_call_id: 3,
          state: 'unresolved',
          resolved_at: Time.now,
          identifier_token: '123'
        }
      end

      phone_call.should_receive(:assign_attributes).with(
        {
          user_id: 2
        },
        anything
      )
      phone_call.merge_attributes! other_phone_call
    end

    it 'selects attrs that have a value' do
      other_phone_call.stub(:attributes) { {user_id: 2, claimer_id: nil, destination_phone_number: ''} }
      phone_call.should_receive(:assign_attributes).with(
        {
          user_id: 2
        },
        anything
      )
      phone_call.merge_attributes! other_phone_call
    end

    it 'selects attrs that are column names' do
      other_phone_call.stub(:attributes) { {user_id: 2, fake: 'test'} }
      phone_call.should_receive(:assign_attributes).with(
        {
          user_id: 2
        },
        anything
      )
      phone_call.merge_attributes! other_phone_call
    end

    it 'assigns attributes without protection' do
      phone_call.should_receive(:assign_attributes).with(
        anything,
        without_protection: true
      )
      phone_call.merge_attributes! other_phone_call
    end

    it 'saves' do
      phone_call.should_receive :save!
      phone_call.merge_attributes! other_phone_call
    end

    it 'works' do
      phone_call = create :phone_call
      other_phone_call = create :phone_call

      phone_call.user_id.should_not == other_phone_call.user_id
      phone_call.merge_attributes! other_phone_call
      phone_call.reload.user_id.should == other_phone_call.user_id
    end
  end

  describe '#publish' do
    let(:phone_call) { build(:phone_call) }

    context 'is called after' do
      it 'create' do
        phone_call.should_receive(:publish)
        phone_call.save!
      end

      it 'update' do
        phone_call.save!
        phone_call.twilio_conference_name = 'poo'
        phone_call.should_receive(:publish)
        phone_call.save!
      end
    end

    context 'new record' do
      before do
        phone_call.stub(:id_changed?) { true }
      end

      it 'does nothing' do
        PubSub.should_not_receive(:publish)
        phone_call.publish
      end
    end

    context 'old record' do
      let(:phone_call) { build_stubbed(:phone_call) }

      before do
        phone_call.stub(:id_changed?) { false }
      end

      it 'publishes that a phone call was updated' do
        PubSub.should_receive(:publish).with(
          "/phone_calls/#{phone_call.id}/update",
          {id: phone_call.id}
        )
        phone_call.publish
      end
    end
  end

  describe '#create_task' do
    let(:phone_call) { build :phone_call }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'outbound' do
      before do
        phone_call.stub(:outbound?) { true }
      end

      it 'does nothing' do
        PhoneCallTask.should_not_receive(:create_if_only_opened_for_phone_call!)
      end
    end

    context 'inbound' do
      before do
        phone_call.stub(:outbound?) { false }
      end

      context 'new record' do
        before do
          phone_call.stub(:id_changed?) { true }
        end

        context 'unclaimed' do
          before do
            phone_call.stub(:unclaimed?) { true }
          end

          it 'creates a task' do
            consult = build :consult
            phone_call.stub(:consult) { consult }
            PhoneCallTask.should_receive(:create_if_only_opened_for_phone_call!).with(phone_call)
            phone_call.create_task
          end
        end

        context 'not unclaimed' do
          before do
            phone_call.stub(:unclaimed?) { false }
          end

          it 'does nothing' do
            PhoneCallTask.should_not_receive(:create_if_only_opened_for_phone_call!)
            phone_call.create_task
          end
        end
      end
    end

  end

  describe 'states' do
    let(:phone_call) { build(:phone_call, to_role_id: @nurse_id) }
    let(:other_phone_call) { build(:phone_call, to_role_id: @nurse_id) }
    let(:nurse) { build_stubbed(:nurse) }
    let(:other_nurse) { build_stubbed(:nurse) }

    before do
      Timecop.freeze()
    end

    after do
      Timecop.return
    end

    describe '#initial state' do
      it 'is unresolved when it\'s an inbound call to a pha' do
        phone_call = create(:phone_call, to_role_id: @pha_id)
        phone_call.should be_unresolved
      end

      it 'is unresolved when it\'s an inbound call without a role' do
        phone_call = create(:phone_call, to_role_id: nil)
        phone_call.should be_unresolved
      end

      it 'is unclaimed when it\'s an inbound call to a nurse' do
        phone_call = create(:phone_call, to_role_id: @nurse_id)
        phone_call.should be_unclaimed
      end

      it 'is dialing when it\'s an outbound call' do
        PhoneCall.any_instance.stub(:dial_origin)
        phone_call = create(:phone_call, outbound: true)
        phone_call.should be_dialing
      end
    end

    describe '#resolve!' do
      let(:phone_call) { build(:phone_call, to_role_id: @pha_id) }

      before do
        phone_call.resolve!
      end

      it 'changes the state to unclaimed' do
        phone_call.should be_unclaimed
      end

      it 'sets the claimed time' do
        phone_call.resolved_at.should == Time.now
      end

      it 'creates a phone call task' do
        phone_call = create :phone_call, to_role_id: @pha_id
        PhoneCallTask.should_receive(:create_if_only_opened_for_phone_call!).with(phone_call)
        phone_call.resolve!
      end
    end

    describe '#merge!' do
      let(:phone_call) { build :phone_call, to_role_id: @pha_id }
      let(:other_phone_call) { build_stubbed :phone_call, to_role_id: @pha_id, state: :claimed, claimer: nurse, claimed_at: Time.now }

      before do
        other_phone_call.stub(:save!)
        phone_call.message.stub(:update_attributes!)
      end

      it 'changes the state to merged' do
        phone_call.merged_into_phone_call = other_phone_call
        phone_call.merge!
        phone_call.should be_merged
      end

      it 'merges attributes' do
        phone_call.merged_into_phone_call = other_phone_call
        other_phone_call.should_receive(:merge_attributes!).with(phone_call)
        phone_call.merge!
      end

      it 'switches the messages phone call' do
        phone_call.merged_into_phone_call = other_phone_call
        phone_call.message.should_receive(:update_attributes!).with(phone_call_id: other_phone_call.id)
        phone_call.merge!
      end

      it 'works' do
        phone_call = create :phone_call
        other_phone_call = create :phone_call, state: :claimed, claimer: nurse, claimed_at: Time.now, message: nil
        message = phone_call.message

        phone_call.merged_into_phone_call = other_phone_call
        phone_call.merge!

        phone_call.should be_merged
        message.reload.phone_call.should == other_phone_call
        other_phone_call.reload.user.should == phone_call.user
      end
    end

    describe '#miss!' do
      before do
        phone_call.miss!
      end

      it 'changes the state to claimed' do
        phone_call.should be_missed
      end

      it 'sets the missed time' do
        phone_call.missed_at.should == Time.now
      end

      it 'abandons all phone call tasks with passed in reason' do
        phone_call = build :phone_call, to_role_id: @pha_id
        phone_call.state = 'unclaimed'
        phone_call_task = build :phone_call_task, phone_call: phone_call
        phone_call_task.should_receive(:update_attributes!).with(state_event: :abandon, reason_abandoned: 'test', abandoner: Member.robot)

        phone_call.stub(:phone_call_tasks) do
          o = Object.new
          o.stub(:where).with(phone_call_id: phone_call.id) do
            [phone_call_task]
          end
          o
        end

        phone_call.miss! 'test'
      end
    end

    describe '#claim!' do
      before do
        phone_call.claimer = nurse
        phone_call.claim!
      end

      it_behaves_like 'cannot transition from', :claim!, [:merged, :dialing, :disconnected, :connected, :missed]

      it 'changes the state to claimed' do
        phone_call.should be_claimed
      end

      it 'sets the claimed time' do
        phone_call.claimed_at.should == Time.now
      end
    end

    describe '#dial!' do
      before do
        phone_call.state = 'claimed'
        phone_call.claimer = nurse
        phone_call.stub(:dial_destination)
      end

      it_behaves_like 'cannot transition from', :dial!, [:unclaimed, :unresolved, :ended, :connected]

      it 'sets the destination phone number to the dialers work phone number' do
        phone_call.dialer = nurse
        phone_call.dial!
        phone_call.destination_phone_number.should == nurse.work_phone_number
      end

      it 'dials the destination' do
        phone_call.dialer = nurse
        phone_call.should_receive(:dial_destination)
        phone_call.dial!
      end

      it 'raises an exception if the dialer is missing' do
        expect { phone_call.dial! }.to raise_error Exception
      end

      it 'raises an exception if the dialer\'s work phone number is missing' do
        nurse.work_phone_number = nil
        phone_call.dialer
        expect { phone_call.dial! }.to raise_error Exception
      end
    end

    describe '#connect!' do
      it_behaves_like 'can transition from', :connect!, [:dialing]
    end

    describe '#disconnect!' do
      it 'transitions missed to missed' do
        phone_call.missed_at = Time.now
        phone_call.state = 'missed'
        phone_call.disconnect!
        phone_call.should be_missed
      end

      it 'transitions unclaimed to missed' do
        phone_call.state = 'unclaimed'
        phone_call.disconnect!
        phone_call.should be_missed
      end

      it 'transitions from dialing to disconnected' do
        phone_call.state = 'dialing'
        phone_call.disconnect!
        phone_call.should be_disconnected
      end

      it 'transitions from connected to disconnected' do
        phone_call.state = 'connected'
        phone_call.disconnect!
        phone_call.should be_disconnected
      end

      it 'transitions from ended to ended' do
        phone_call.ender = nurse
        phone_call.ended_at = Time.now
        phone_call.state = 'ended'
        phone_call.disconnect!
        phone_call.should be_ended
      end

      it 'doesn\'t abandoned phone call tasks if the phone call is already missed' do
        phone_call.missed_at = Time.now
        phone_call.state = 'missed'
        phone_call.should_not_receive(:phone_call_tasks)
        PhoneCallTask.any_instance.should_not_receive(:update_attributes!)
        phone_call.disconnect!
      end
    end

    describe '#end!' do
      before do
        phone_call.state = 'claimed'
        phone_call.ender = nurse
        phone_call.end!
      end

      it_behaves_like 'cannot transition from', :end!, [:unclaimed, :unresolved]

      it 'changes the state to ended' do
        phone_call.should be_ended
      end

      it 'sets the ended time' do
        phone_call.ended_at.should == Time.now
      end

    end

    describe '#reclaim!' do
      before do
        phone_call.state = 'ended'
        phone_call.ender = other_nurse
        phone_call.ended_at = Time.now
        phone_call.claimer = nurse
        phone_call.reclaim!
      end

      it 'changes the state to claimed' do
        phone_call.should be_claimed
      end

      it 'unsets the ender' do
        phone_call.ender.should be_nil
      end

      it 'unsets the ended time' do
        phone_call.ended_at.should be_nil
      end

      it 'sets the claimed time' do
        phone_call.claimed_at.should == Time.now
      end
    end

    describe '#unclaim!' do
      before do
        phone_call.state = 'claimed'
        phone_call.claimer = nurse
        phone_call.claimed_at = Time.now

        phone_call.unclaim!
      end

      it 'changes the state to unclaimed' do
        phone_call.should be_unclaimed
      end

      it 'unsets the claimer' do
        phone_call.claimer.should be_nil
      end

      it 'unsets the ended time' do
        phone_call.claimed_at.should be_nil
      end
    end
  end
end
