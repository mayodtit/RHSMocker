require 'spec_helper'

describe PhoneCall do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :destination_phone_number

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

      @nurse = create :hcp
      @other_nurse = create :hcp
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
