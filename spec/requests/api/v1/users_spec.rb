require 'spec_helper'

describe 'Users' do
  describe 'POST /api/v1/user/update_password' do
    def do_request
      post '/api/v1/user/update_password', :current_password => password, :password => 'NewPassword!'
    end

    let!(:user) { create(:user_with_email) }
    let(:password) { 'password' }

    before(:each) do
      user.login
    end

    it "updates the user's password" do
      lambda{ do_request }.should change(user, :crypted_password)
    end
  end

  describe 'POST /api/v1/users/:id/invite' do
    def do_request
      post "/api/v1/users/#{user_id}/invite", auth_token: current_user.auth_token
    end

    let!(:current_user) { create(:user_with_email) }

    before(:each) do
      current_user.login
    end

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
