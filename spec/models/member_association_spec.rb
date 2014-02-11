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

  describe 'state machine' do
    describe 'states' do
      it 'sets the initial state to pending' do
        expect(described_class.new.state?(:pending)).to be_true
      end
    end
  end
end
