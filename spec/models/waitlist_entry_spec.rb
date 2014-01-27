require 'spec_helper'

describe WaitlistEntry do
  let(:waitlist_entry) { build(:waitlist_entry) }

  it_has_a 'valid factory'
  it_has_a 'valid factory', :invited
  it_has_a 'valid factory', :claimed
  it_has_a 'valid factory', :revoked
  it_validates 'presence of', :email
  it_validates 'uniqueness of', :email
  it 'validates email format' do
    expect(waitlist_entry).to be_valid
    waitlist_entry.email = 'junk'
    expect(waitlist_entry).to_not be_valid
  end
  it_validates 'foreign key of', :creator
  it_validates 'foreign key of', :claimer
  it_validates 'foreign key of', :revoker
  it_validates 'foreign key of', :feature_group

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

      describe 'revoked' do
        let(:waitlist_entry) { build(:waitlist_entry, :revoked) }

        it 'validates presence of revoker' do
          expect(waitlist_entry).to be_valid
          waitlist_entry.revoker = nil
          expect(waitlist_entry).to_not be_valid
        end

        it 'validates presence of revoked_at' do
          expect(waitlist_entry).to be_valid
          waitlist_entry.revoked_at = nil
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

        context 'with feature_group' do
          let(:claimer) { create(:member) }
          let(:feature_group) { create(:feature_group) }
          let(:waitlist_entry) { build(:waitlist_entry, :invited, claimer: claimer,
                                                                  feature_group: feature_group) }

          it 'adds the feature_group to the claimer' do
            expect(claimer.feature_groups).to_not include(feature_group)
            expect(waitlist_entry.claim).to be_true
            expect(claimer.feature_groups).to include(feature_group)
          end
        end
      end

      describe 'revoke' do
        let(:waitlist_entry) { build(:waitlist_entry, :invited, revoker: create(:member)) }

        it 'sets state to revoked' do
          expect(waitlist_entry.revoke).to be_true
          expect(waitlist_entry.state?(:revoked)).to be_true
        end

        it 'sets revoked_at' do
          expect(waitlist_entry.revoked_at).to be_nil
          expect(waitlist_entry.revoke).to be_true
          expect(waitlist_entry.revoked_at).to_not be_nil
        end

        it 'unsets the token' do
          expect(waitlist_entry.token).to_not be_nil
          expect(waitlist_entry.revoke).to be_true
          expect(waitlist_entry.token).to be_nil
        end
      end
    end
  end
end
