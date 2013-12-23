require 'spec_helper'

describe PhoneCall do
  it_has_a 'valid factory'

  describe 'validations' do
    before do
      PhoneCall.any_instance.stub(:generate_identifier_token)
    end

    it_validates 'presence of', :user
    it_validates 'presence of', :destination_phone_number
    it_validates 'presence of', :identifier_token
    it_validates 'uniqueness of', :identifier_token
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
  end

  describe 'states' do
    before do
      Timecop.freeze()
    end

    after do
      Timecop.return
    end

    before :each do
      @phone_call = PhoneCall.new
      @phone_call.user = create :member
      @phone_call.destination_phone_number = '311'
      @phone_call.message =  create :message

      @nurse = create :nurse
      @other_nurse = create :nurse
    end

    describe ':unclaimed' do
      it 'is the initial state' do
        @phone_call.should be_unclaimed
      end
    end

    describe '#claim!' do
      before do
        @phone_call.claim! @nurse
      end

      it 'changes the state to claimed' do
        @phone_call.should be_claimed
      end

      it 'sets the claimer' do
        @phone_call.claimer.should == @nurse
      end

      it 'sets the claimed time' do
        @phone_call.claimed_at.should == Time.now
      end
    end

    describe '#end!' do
      before do
        @phone_call.state = 'claimed'
        @phone_call.end! @other_nurse
      end

      it 'changes the state to ended' do
        @phone_call.should be_ended
      end

      it 'sets the ender' do
        @phone_call.ender.should == @other_nurse
      end

      it 'sets the ended time' do
        @phone_call.ended_at.should == Time.now
      end
    end

    describe '#reclaim!' do
      before do
        @phone_call.state = 'ended'
        @phone_call.ender = @other_nurse
        @phone_call.ended_at = Time.now

        @phone_call.reclaim!
      end

      it 'changes the state to claimed' do
        @phone_call.should be_claimed
      end

      it 'unsets the ender' do
        @phone_call.ender.should be_nil
      end

      it 'unsets the ended time' do
        @phone_call.ended_at.should be_nil
      end
    end

    describe '#unclaim!' do
      before do
        @phone_call.state = 'claimed'
        @phone_call.claimer = @nurse
        @phone_call.claimed_at = Time.now

        @phone_call.unclaim!
      end

      it 'changes the state to unclaimed' do
        @phone_call.should be_unclaimed
      end

      it 'unsets the claimer' do
        @phone_call.claimer.should be_nil
      end

      it 'unsets the ended time' do
        @phone_call.claimed_at.should be_nil
      end
    end
  end
end
