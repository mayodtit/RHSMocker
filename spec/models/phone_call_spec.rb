require 'spec_helper'

describe PhoneCall do
  it_has_a 'valid factory'

  describe 'validations' do
    before do
      PhoneCall.any_instance.stub(:generate_identifier_token)
    end

    it_validates 'presence of', :user
    it_validates 'presence of', :identifier_token
    it_validates 'uniqueness of', :identifier_token
  end

  describe 'phone numbers' do
    let(:phone_call) { build(:phone_call) }

    it_validates 'phone number format of', :origin_phone_number
    it_validates 'phone number format of', :destination_phone_number, true
  end

  describe '#outbound?' do
    let(:phone_call) { build_stubbed(:phone_call) }

    it 'is false if the phone_call is to a role' do
      phone_call.to_role = nil
      phone_call.should be_outbound
    end

    it 'is true if the phone_call is not to any role' do
      phone_call.to_role = build_stubbed(:role)
      phone_call.should_not be_outbound
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
    end

    describe '#dial_if_outbound' do
      it 'is called after create' do
        phone_call = build(:phone_call)
        phone_call.should_receive :dial_if_outbound
        phone_call.save!
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
    let(:phone_call) { build(:phone_call) }
    let(:connect_url) { '/connect' }
    let(:status_url) { '/status' }

    before do
      PhoneNumberUtil.stub(:format_for_dialing) do |number|
        "1#{number}"
      end
    end

    describe '#dial_origin' do
      it 'dials the origin phone number via twilio' do
        URL_HELPERS.stub(:connect_origin_api_v1_phone_call_url).with(phone_call) { connect_url }
        URL_HELPERS.stub(:status_origin_api_v1_phone_call_url).with(phone_call) { status_url }

        PhoneCall.twilio.account.calls.should_receive(:create).with(
          from: "1#{TWILIO_CALLER_ID}",
          to: "1#{phone_call.origin_phone_number}",
          url: connect_url,
          method: 'POST',
          status_callback: status_url,
          status_callback_method: 'POST'
        )

        phone_call.dial_origin
      end
    end

    describe '#dial_destination' do
      it 'dials the destination phone number via twilio' do
        URL_HELPERS.stub(:connect_destination_api_v1_phone_call_url).with(phone_call) { connect_url }
        URL_HELPERS.stub(:status_destination_api_v1_phone_call_url).with(phone_call) { status_url }

        PhoneCall.twilio.account.calls.should_receive(:create).with(
          from: "1#{TWILIO_CALLER_ID}",
          to: "1#{phone_call.destination_phone_number}",
          url: connect_url,
          method: 'POST',
          status_callback: status_url,
          status_callback_method: 'POST'
        )

        phone_call.dial_destination
      end
    end
  end

  describe 'states' do
    let(:phone_call) { build(:phone_call) }
    let(:nurse) { build_stubbed(:nurse) }
    let(:other_nurse) { build_stubbed(:nurse) }

    before do
      Timecop.freeze()
    end

    after do
      Timecop.return
    end

    describe 'initial state' do
      it 'is unclaimed when it\'s an inbound call' do
        phone_call = create(:phone_call, to_role: build(:role))
        phone_call.should be_unclaimed
      end

      it 'is dialing when it\'s an outbound call' do
        phone_call = create(:phone_call, to_role: nil)
        phone_call.should be_dialing
      end
    end

    describe '#claim!' do
      before do
        phone_call.claim! nurse
      end

      it 'changes the state to claimed' do
        phone_call.should be_claimed
      end

      it 'sets the claimer' do
        phone_call.claimer.should == nurse
      end

      it 'sets the claimed time' do
        phone_call.claimed_at.should == Time.now
      end
    end

    describe '#connect!' do
      it_behaves_like 'can transition from', :connect!, :connected, [:claimed, :dialing]
    end

    describe '#end!' do
      before do
        phone_call.state = 'claimed'
        phone_call.end! other_nurse
      end

      it_behaves_like 'can transition from', :end!, :ended, [:connected, :claimed]

      it 'changes the state to ended' do
        phone_call.should be_ended
      end

      it 'sets the ender' do
        phone_call.ender.should == other_nurse
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
