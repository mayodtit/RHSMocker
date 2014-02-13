require 'spec_helper'

describe Association do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :disabled
  it_has_a 'valid factory', :pending
  it_has_a 'valid factory', :member_associate
  it_validates 'presence of', :user
  it_validates 'presence of', :associate
  it_validates 'presence of', :creator
  it_validates 'uniqueness of', :associate_id, :user_id, :association_type_id
  it_validates 'foreign key of', :replacement
  it_validates 'foreign key of', :pair
  it 'validates the user is not the associate' do
    user = build_stubbed(:user)
    build_stubbed(:association, user: user, associate: user).should_not be_valid
  end
  it 'validates creator does not change' do
    association = create(:association)
    expect(association.update_attributes(creator: create(:member))).to be_false
    expect(association).to_not be_valid
    expect(association.errors[:creator_id]).to include('cannot be changed')
  end

  describe '#invite!' do
    context 'without a Member' do
      let(:associate) { create(:user, email: 'kyle@test.getbetter.com') }
      let!(:association) { create(:association, associate: associate) }

      before do
        association.user.stub_chain(:invitations, :create)
      end

      it 'creates a Member' do
        expect{ association.invite! }.to change(Member, :count).by(1)
      end

      it 'invites the Member' do
        association.user.invitations.should_receive(:create).once
        association.invite!
      end
    end

    context 'with a Member' do
      let!(:member) { create(:member) }
      let!(:associate) { create(:user, email: member.email) }
      let!(:association) { create(:association, associate: associate) }

      it 'creates a pending Association' do
        expect(association.replacement).to be_nil
        expect{ association.invite! }.to change(Association, :count).by(1)
        expect(association.reload.replacement).to be_persisted
        expect(association.replacement.state?(:pending)).to be_true
      end
    end
  end

  describe 'state_machine' do
    describe 'states' do
      it 'sets the initial state to enabled' do
        expect(described_class.new.state?(:enabled)).to be_true
      end
    end

    describe 'events' do
      describe 'enable' do
        let(:association) { build(:association, :disabled) }

        it 'sets disabled to enabled' do
          expect(association.enable).to be_true
          expect(association.state?(:enabled)).to be_true
        end

        context 'when pending' do
          let(:association) { create(:association, :pending) }

          it 'creates an enabled pair association' do
            expect(association.enable).to be_true
            expect(association.reload.state?(:enabled)).to be_true
            pair = association.pair
            expect(pair).to be_persisted
            expect(pair.user).to eq(association.associate)
            expect(pair.associate).to eq(association.user)
            expect(pair.state?(:enabled)).to be_true
            expect(pair.pair).to eq(association)
          end

          context 'with an original association' do
            let(:association) { create(:association, :pending, original: create(:association)) }

            it 'disables the original association' do
              expect(association.enable).to be_true
              expect(association.state?(:enabled)).to be_true
              expect(association.original.state?(:disabled)).to be_true
            end
          end
        end
      end

      describe 'disable' do
        let(:association) { build(:association) }

        it 'sets enabled to disabled' do
          expect(association.disable).to be_true
          expect(association.state?(:disabled)).to be_true
        end
      end
    end
  end
end
