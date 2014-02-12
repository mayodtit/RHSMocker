require 'spec_helper'

describe MemberAssociation do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :enabled
  it_has_a 'valid factory', :disabled
  it 'validates associate is a member' do
    expect(build_stubbed(:member_association,
                         associate: build_stubbed(:user))).to_not be_valid
    expect(build_stubbed(:member_association,
                         associate: build_stubbed(:member))).to be_valid
  end
  it_validates 'foreign key of', :pair

  describe 'state machine' do
    describe 'states' do
      it 'sets the initial state to pending' do
        expect(described_class.new.state?(:pending)).to be_true
      end
    end

    describe 'events' do
      describe 'enable' do
        let(:association) { create(:member_association) }

        it 'creates an enabled pair association' do
          expect(association.enable).to be_true
          expect(association.state?(:enabled)).to be_true
          pair = association.pair
          expect(pair).to be_persisted
          expect(pair.user).to eq(association.associate)
          expect(pair.associate).to eq(association.user)
          expect(pair.state?(:enabled)).to be_true
          expect(pair.pair).to eq(association)
        end

        context 'with an original association' do
          let(:association) { create(:member_association, original: create(:association)) }

          it 'disables the original association' do
            expect(association.enable).to be_true
            expect(association.state?(:enabled)).to be_true
            expect(association.original.state?(:disabled)).to be_true
          end
        end
      end
    end
  end
end
