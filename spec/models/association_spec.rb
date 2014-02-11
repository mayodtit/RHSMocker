require 'spec_helper'

describe Association do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :associate
  it_validates 'uniqueness of', :associate_id, :user_id, :association_type_id
  it_validates 'foreign key of', :replacement
  it 'validates the user is not the associate' do
    user = build_stubbed(:user)
    build_stubbed(:association, user: user, associate: user).should_not be_valid
  end

  describe 'state_machine' do
    describe 'states' do
      it 'sets the initial state to enabled' do
        expect(described_class.new.state?(:enabled)).to be_true
      end
    end

    describe 'events' do
      describe 'disable' do
        let(:association) { build(:association) }

        it 'sets enabled to disabled' do
          expect(association.disable).to be_true
          expect(association.state?(:disabled)).to be_true
        end
      end

      describe 'enable' do
        let(:association) { build(:association, :disabled) }

        it 'sets disabled to enabled' do
          expect(association.enable).to be_true
          expect(association.state?(:enabled)).to be_true
        end
      end
    end
  end
end
