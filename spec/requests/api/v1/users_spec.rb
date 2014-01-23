require 'spec_helper'

shared_examples 'creates a member' do
  it 'creates a new member and returns member and auth_token' do
    expect{ do_request(member_params) }.to change(Member, :count).by(1)
    expect(response).to be_success
    body = JSON.parse(response.body, symbolize_names: true)
    member = Member.find(body[:user][:id])
    expect(body[:user].to_json).to eq(member.as_json.to_json)
    expect(body[:auth_token]).to eq(member.auth_token)
  end
end

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
        expect(body[:user].to_json).to eq(user.as_json.to_json)
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
        expect(body[:user].to_json).to eq(user.as_json.to_json)
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
        expect(body[:user].to_json).to eq(user.as_json.to_json)
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
        expect(body[:user].to_json).to eq(user.reload.as_json.to_json)
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
        expect(body[:user].to_json).to eq(user.reload.as_json.to_json)
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
        expect(body[:user].to_json).to eq(user.reload.as_json.to_json)
        expect(body[:user][:first_name]).to eq(new_name)
      end
    end
  end

  describe 'POST /api/v1/users' do
    def do_request(params={})
      post '/api/v1/users', params
    end

    let(:member_params) { {user: attributes_for(:member)} }

    it_behaves_like 'creates a member'

    context 'with invite flow enabled' do
      before do
        Metadata.stub(use_invite_flow?: true)
      end

      context 'with an invite token' do
        let!(:waitlist_entry) { create(:waitlist_entry, :invited) }
        let(:member_params) { {user: (attributes_for(:member).merge!(token: waitlist_entry.token))} }

        it_behaves_like 'creates a member'

        it 'claims the invite token' do
          do_request(member_params)
          body = JSON.parse(response.body, symbolize_names: true)
          member = Member.find(body[:user][:id])
          expect(waitlist_entry.reload.state?(:claimed)).to be_true
          expect(waitlist_entry.claimer).to eq(member)
        end
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
