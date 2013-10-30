require 'spec_helper'


describe Invitation do
  it_has_a 'valid factory'
  it_validates 'presence of', :member
  it_validates 'presence of', :invited_member
  it_validates 'presence of', :token
  it_validates 'uniqueness of', :invited_member_id, :member_id
  it_validates 'uniqueness of', :token

  describe '#generate_token' do
    it 'generates unique tokens' do
      invitationA = Invitation.new
      invitationB = Invitation.new

      invitationA.send :generate_token
      invitationB.send :generate_token

      invitationA.token.should_not == invitationB.token
    end
  end

  it 'generates a token before validation only on creation' do
    invitation = Invitation.new member: create(:hcp), invited_member: create(:member)
    invitation.stub :invite_member!
    invitation.should_receive(:generate_token).and_call_original
    invitation.save!
    invitation.member = create :hcp
    invitation.should_not_receive :generate_token
    invitation.save!
  end

  describe 'states' do
    before :each do
      @invited_member = create :member
      @invitation = Invitation.new
      @invitation.token = '12346789'
      @invitation.member = create :member
      @invitation.invited_member = @invited_member
    end

    describe ':unclaimed' do
      it 'is the initial state' do
        @invitation.should be_unclaimed
      end
    end

    describe '#claim!' do
      it 'changes to claimed on claim' do
        @invitation.claim!
        @invitation.should be_claimed
      end

      it 'unclaimed all other invitations' do
        @invitation.save!
        @other_invitation =
          Invitation.create! :token => '1', :member => create(:member), :invited_member => @invited_member
        @another_invitation =
          Invitation.create! :token => '2', :member => create(:member), :invited_member => @invited_member

        @invitation.claim!

        @other_invitation.reload()
        @another_invitation.reload()

        @other_invitation.should be_voided
        @another_invitation.should be_voided
      end
    end
  end
end
