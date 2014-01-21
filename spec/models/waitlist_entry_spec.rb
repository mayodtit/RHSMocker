require 'spec_helper'

describe WaitlistEntry do
  let(:waitlist_entry) { build(:waitlist_entry) }

  it_has_a 'valid factory'
  it_has_a 'valid factory', :invited
  it_has_a 'valid factory', :claimed
  it_validates 'presence of', :email
  it_validates 'uniqueness of', :email
  it 'validates email format' do
    expect(waitlist_entry).to be_valid
    waitlist_entry.email = 'junk'
    expect(waitlist_entry).to_not be_valid
  end
  it_validates 'foreign key of', :creator
  it_validates 'foreign key of', :claimer

  describe '#generate_token' do
    it 'sets the waitlist_entry token' do
      expect(waitlist_entry.token).to be_nil
      waitlist_entry.generate_token
      expect(waitlist_entry.token).to_not be_nil
    end

    it 'sets a token with length of 5' do
      expect(waitlist_entry.generate_token.length).to eq(5)
    end
  end

  describe 'state machine' do
    describe 'states' do
      it 'sets the initial state to waiting' do
        expect(described_class.new.state?(:waiting)).to be_true
      end

      describe 'invited' do
        let(:waitlist_entry) { build(:waitlist_entry, :invited) }

        it 'validates presence of token' do
          expect(waitlist_entry).to be_valid
          waitlist_entry.token = nil
          expect(waitlist_entry).to_not be_valid
        end

        it 'validates presence of invited_at' do
          expect(waitlist_entry).to be_valid
          waitlist_entry.invited_at = nil
          expect(waitlist_entry).to_not be_valid
        end
      end

      describe 'claimed' do
        let(:waitlist_entry) { build(:waitlist_entry, :claimed) }

        it 'validates presence of claimer' do
          expect(waitlist_entry).to be_valid
          waitlist_entry.claimer = nil
          expect(waitlist_entry).to_not be_valid
        end

        it 'validates presence of claimed_at' do
          expect(waitlist_entry).to be_valid
          waitlist_entry.claimed_at = nil
          expect(waitlist_entry).to_not be_valid
        end

        it 'validates token is nil' do
          expect(waitlist_entry).to be_valid
          waitlist_entry.token = 'abcde'
          expect(waitlist_entry).to_not be_valid
        end
      end
    end

    describe 'events' do
      describe 'invite' do
        it 'sets waiting to invited' do
          expect(waitlist_entry.invite).to be_true
          expect(waitlist_entry.state?(:invited)).to be_true
        end

        it 'sets invited_at' do
          expect(waitlist_entry.invited_at).to be_nil
          expect(waitlist_entry.invite).to be_true
          expect(waitlist_entry.invited_at).to_not be_nil
        end

        it 'sets the token' do
          expect(waitlist_entry.token).to be_nil
          expect(waitlist_entry.invite).to be_true
          expect(waitlist_entry.token).to_not be_nil
        end

        it 'emails the waitlist email' do
          UserMailer.stub_chain(:waitlist_invite_email, :deliver)
          UserMailer.should_receive(:waitlist_invite_email).with(waitlist_entry).once
          waitlist_entry.invite
        end
      end

      describe 'claim' do
        let(:waitlist_entry) { build(:waitlist_entry, :invited, claimer: create(:member)) }

        it 'sets invited to claimed' do
          expect(waitlist_entry.claim).to be_true
          expect(waitlist_entry.state?(:claimed)).to be_true
        end

        it 'sets claimed_at' do
          expect(waitlist_entry.claimed_at).to be_nil
          expect(waitlist_entry.claim).to be_true
          expect(waitlist_entry.claimed_at).to_not be_nil
        end

        it 'unsets the token' do
          expect(waitlist_entry.token).to_not be_nil
          expect(waitlist_entry.claim).to be_true
          expect(waitlist_entry.token).to be_nil
        end
      end
    end
  end
end
