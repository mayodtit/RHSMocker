require 'spec_helper'

describe 'Users' do
  context 'with an existing record' do
    let!(:user) { create(:member) }

    describe 'GET /api/v1/users/:id' do
      def do_request
        get "/api/v1/users/#{user.id}", auth_token: user.auth_token
      end

      it 'shows the user' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user].to_json).to eq(user.serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/current' do
      def do_request
        get "/api/v1/users/current", auth_token: user.auth_token
      end

      it 'shows the current_user' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user].to_json).to eq(user.serializer(include_roles: true).as_json.to_json)
      end
    end

    describe 'DEPRECATED GET /api/v1/user' do
      def do_request
        get "/api/v1/user", auth_token: user.auth_token
      end

      it 'shows the current_user' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user].to_json).to eq(user.serializer(include_roles: true).as_json.to_json)
      end
    end

    describe 'PUT /api/v1/users/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}", params.merge!(auth_token: user.auth_token)
      end

      let(:new_name) { 'Barrack' }

      it 'updates the user' do
        do_request(user: {first_name: new_name})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user].to_json).to eq(user.reload.serializer.as_json.to_json)
        expect(body[:user][:first_name]).to eq(new_name)
      end
    end

    describe 'DEPRECATED PUT /api/v1/user/:id' do
      def do_request(params={})
        put "/api/v1/user/#{user.id}", params.merge!(auth_token: user.auth_token)
      end

      let(:new_name) { 'Bill' }

      it 'updates the user' do
        do_request(user: {first_name: new_name})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user].to_json).to eq(user.reload.serializer.as_json.to_json)
        expect(body[:user][:first_name]).to eq(new_name)
      end
    end

    describe 'DEPRECATED PUT /api/v1/user' do
      def do_request(params={})
        put '/api/v1/user', params.merge!(auth_token: user.auth_token)
      end

      let(:new_name) { 'George' }

      it 'updates the current_user' do
        do_request(user: {first_name: new_name})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user].to_json).to eq(user.reload.serializer.as_json.to_json)
        expect(body[:user][:first_name]).to eq(new_name)
      end
    end
  end

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

    let!(:current_user) { create(:member) }

    context 'for a member' do
      let!(:user) { create(:member, :invited) }
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
