require 'spec_helper'

describe 'PasswordResets' do
  describe 'POST /api/v1/password_resets' do
    let!(:user) { create(:user_with_email) }

    def do_request
      post '/api/v1/password_resets', :email => user.email
    end

    it 'sends the user an e-mail with a reset password link and token' do
      UserMailer.should_receive(:reset_password_email).with(user)
      do_request
    end
  end

  # TODO - why is the ID used in this route?
  describe 'PUT /api/v1/password_resets/:id' do
    let(:token) { '123456' }
    let!(:user) { create(:user_with_email, :reset_password_token => token) }
    let(:new_password) { 'SuperSekretPassword' }

    def do_request
      post '/api/v1/password_resets', :token => token,
                                      :user => {:password => new_password,
                                                :password_confirmation => new_password}
    end

    it "changes the user's password" do
      old_password_hash = user.crypted_password
      do_request
      user.crypted_password.should_not == old_password_hash
    end
  end
end
