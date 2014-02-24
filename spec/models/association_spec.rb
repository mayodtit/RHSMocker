require 'spec_helper'

describe Association do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :disabled
  it_has_a 'valid factory', :pending
  it_has_a 'valid factory', :member_associate
  it_validates 'presence of', :user
  it_validates 'presence of', :associate
  it_validates 'presence of', :creator
  it_validates 'presence of', :permission
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

  describe 'callbacks' do
    describe '#create_default_permission' do
      it 'creates defaults on create' do
        expect{ create(:association) }.to change(Permission, :count).by(1)
      end

      it 'creates the permission for the association' do
        association = create(:association)
        permission = association.permission
        expect(permission).to be_persisted
        expect(permission.reload.subject).to eq(association)
        expect(association.reload.permission).to eq(permission)
      end
    end
  end

  describe '::for_user_id_or_associate_id' do
    let!(:user) { create(:member) }
    let!(:association) { create(:association, user: user) }
    let!(:inverse_association) { create(:association, associate: user) }

    it 'returns records for both user_id and associate_id' do
      results = described_class.for_user_id_or_associate_id(user.id)
      expect(results).to include(association, inverse_association)
    end
  end

  describe '#invite!' do
    context 'without a Member' do
      let(:owner) { create(:member) }
      let(:associate) { create(:user, email: 'kyle@test.getbetter.com', owner: owner) }
      let!(:association) { create(:association, user: owner, associate: associate) }

      # TODO - these specs probably reach too far out of this model
      it 'creates a Member' do
        expect{ association.invite! }.to change(Member, :count).by(1)
      end

      it 'invites the Member' do
        expect{ association.invite! }.to change(Invitation, :count).by(1)
      end
    end

    context 'with a Member' do
      let(:owner) { create(:member) }
      let!(:member) { create(:member) }
      let!(:associate) { create(:user, email: member.email, owner: owner) }
      let!(:association) { create(:association, user: owner, associate: associate) }

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
      describe 'initial state' do
        context 'creator is originating user' do
          let(:association) { described_class.new }

          xit 'is enabled' do
            expect(association.state?(:enabled)).to be_true
          end
        end

        context 'creator is not originating user' do
          let(:association) { described_class.new(creator: build_stubbed(:member)) }

          xit 'is pending' do
            expect(association.state?(:pending)).to be_true
          end
        end
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
              expect(association.original.reload.state?(:disabled)).to be_true
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

        context 'with an original association' do
          let(:association) { create(:association, original: create(:association, :disabled)) }

          it 'enables the original association' do
            expect(association.disable).to be_true
            expect(association.state?(:disabled)).to be_true
            expect(association.original.reload.state?(:enabled)).to be_true
          end
        end
      end
    end
  end
end
