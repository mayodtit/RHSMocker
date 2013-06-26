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
end
