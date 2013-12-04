require 'spec_helper'

describe 'Users' do
  describe 'DEPRECATED POST /api/v1/user/update_email' do
    def do_request
      post '/api/v1/user/update_email', auth_token: user.auth_token,
                                        password: password,
                                        email: new_email
    end

    let!(:user) { create(:member) }
    let(:password) { 'password' }
    let(:new_email) { 'new_email@getbetter.com' }

    it "updates the user's email" do
      user.reload.email.should_not == new_email
      do_request
      user.reload.email.should == new_email
    end
  end

  describe 'DEPRECATED POST /api/v1/user/update_password' do
    def do_request
      post '/api/v1/user/update_password', auth_token: user.auth_token,
                                           current_password: password,
                                           password: new_password
    end

    let!(:user) { create(:user_with_email) }
    let(:password) { 'password' }
    let(:new_password) { 'NewPassword!' }

    it "updates the user's password" do
      Member.authenticate(user.email, new_password).should be_nil
      do_request
      Member.authenticate(user.email, new_password).should == user
    end
  end

  describe 'POST /api/v1/users/:id/invite' do
    def do_request
      post "/api/v1/users/#{user_id}/invite", auth_token: current_user.auth_token
    end

    let!(:current_user) { create(:user_with_email) }

    context 'for a member' do
      let!(:user) { create(:user_with_email, password: nil, password_confirmation: nil) }
      let!(:user_id) { user.id }

      it 'sets the members invite token' do
        do_request
        user.reload.invitation_token.should_not be_nil
      end
    end

    context 'for a ghost user' do
      let!(:user) { create(:user, :email => "ghost@test.com") }
      let!(:user_id) { user.id }

      it 'creates a new member' do
        lambda { do_request }.should change(Member, :count).by(1)
        user.member.should_not be_nil
      end

      it 'sets the members invite token' do
        do_request
        user.member.invitation_token.should_not be_nil
      end
    end
  end
end
