require 'spec_helper'

describe Api::V1::InvitationsController do
  let(:user) { build_stubbed :member, :premium }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:email) { 'nurse@example.com' }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'POST create' do
    def do_request
      post :create, auth_token: user.auth_token, user: {email: email}
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      before do
        @invited_member = build_stubbed :member, :invited
      end

      context 'invited user does not exist' do
        context 'when user params are valid' do
          it 'creates a user with only email, first name, and last name' do
            user_params = {'email' => email, 'first_name' => 'Paula', 'last_name' => 'Abdul', 'password' => 'hello', 'password_confirm' => 'hello'}
            filtered_params = user_params.select { |key, value| key.match(/^(email)|(first_name)|(last_name)/) }

            Member.should_receive(:create).with(filtered_params) { @invited_member }

            post :create, auth_token: user.auth_token, user: user_params
          end

          it 'creates an invitation to the user' do
            Member.stub(:create) { @invited_member }
            user.should_receive(:invitations) do
              o = Object.new
              o.should_receive(:create).with(invited_member: @invited_member)
              o
            end
            do_request
          end
        end

        context 'when user params aren\'t valid' do
          before do
            @invited_member.stub(:valid?) { false }
            Member.stub(:create) { @invited_member }
          end

          it_behaves_like 'failure'
        end
      end

      context 'invited user exists' do
        before do
          Member.stub(:find_by_email).with(email) { @invited_member }
        end

        context 'and is signed up' do
          let(:delayed_rhs_mailer) { double('delayed RHS mailer') }

          before do
            @invited_member.stub(:signed_up?) { true }
            RHSMailer.stub(delay: delayed_rhs_mailer)
            delayed_rhs_mailer.stub(:assigned_role_email)
          end

          it_behaves_like 'success'

          it 'downcases email' do
            post :create, auth_token: user.auth_token, user: {email: email.upcase}
            response.should be_success
          end

          it 'assigns nurse role to the user' do
            @invited_member.should_receive(:add_role).with :nurse
            do_request
          end

          it 'sends an email that the role has been assigned' do
            url = 'http://localhost:4567/#/login?next=%2Fsettings%2Fprofile'
            Mails::AssignedRoleJob.should_receive(:create)
                                  .with(@invited_member.id,
                                        url,
                                        user.full_name)
            do_request
          end
        end

        context 'and is not signed up' do
          before do
            @invited_member = build_stubbed :member, :invited
            Member.stub(:find_by_email).with(email) { @invited_member }
          end

          it_behaves_like 'success'

          it 'downcases email' do
            post :create, auth_token: user.auth_token, user: {email: email.upcase}
            response.should be_success
          end

          it 'assigns nurse role to the user' do
            @invited_member.should_receive(:add_role).with :nurse
            do_request
          end

          it 'creates an invitation to the user' do
            user.should_receive(:invitations) do
              o = Object.new
              o.should_receive(:create).with(invited_member: @invited_member)
              o
            end
            do_request
          end

          context 'and has been invited' do
            before do
              @invitation = build_stubbed :invitation
              Invitation.stub(:find_by_invited_member_id).with(@invited_member.id) { @invitation }
            end

            it_behaves_like 'success'

            it 'invites the member again' do
              @invitation.should_receive :invite_member!
              do_request
            end
          end
        end
      end
    end
  end

  shared_examples 'invitation 404' do
    context 'invitation doesn\'t exist or is claimed' do
      before do
        Invitation.stub(:where).with(state: :unclaimed) {
          o = Object.new
          o.stub(:find_by_token!) { raise(ActiveRecord::RecordNotFound) }
          o
        }
      end

      it_behaves_like '404'
    end
  end

  describe 'GET show' do
    let(:invitation_token) { 'ABCD' }

    def do_request
      get :show, id: invitation_token
    end

    it_behaves_like 'invitation 404'

    context 'invitation exists' do
      before do
        @invitation = build_stubbed :invitation
        Invitation.stub(find_by_token!: @invitation)
      end

      it_behaves_like 'success'
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, id: 'ABCD'
    end

    it_behaves_like 'invitation 404'

    context 'invitation exists' do
      let(:agreement) { build_stubbed(:agreement, :active) }

      before do
        @invitation = build_stubbed :invitation
        Invitation.stub(find_by_token!: @invitation)
        Agreement.stub(active: agreement)
      end

      let(:user_params) {
        {
          'email' => email, 'first_name' => 'Paula', 'last_name' => 'Abdul',
          'password' => 'hello', 'password_confirmation' => 'hello',
          'invitation_token' => 'hello'
        }
      }

      it 'updates the invited member with email, first name, last name, and password' do
        filtered_params = user_params.select { |key, value| key.match(/^(email)|(first_name)|(last_name)|(password)|(password_confirmation)/) }
        filtered_params['user_agreements_attributes'] = [{'agreement_id' => agreement.id, 'ip_address' => 'SERVER', 'user_agent' => 'SERVER'}]

        @invitation.invited_member.should_receive(:update_attributes).with(filtered_params)
        @invitation.stub(:claim!)

        put :update, id: 'ABCD', user: user_params
      end

      it 'downcases email' do
        user_params_w_upcase_email = user_params.clone
        user_params_w_upcase_email['email'] = user_params['email'].upcase
        filtered_params = user_params.select { |key, value| key.match(/^(email)|(first_name)|(last_name)|(password)|(password_confirmation)/) }
        filtered_params['user_agreements_attributes'] = [{'agreement_id' => agreement.id, 'ip_address' => 'SERVER', 'user_agent' => 'SERVER'}]

        @invitation.invited_member.should_receive(:update_attributes).with(filtered_params)
        @invitation.stub(:claim!)

        put :update, id: 'ABCD', user: user_params_w_upcase_email
      end

      context 'user attributes are valid' do
        def do_request
          put :update, id: 'ABCD', user: user_params
        end

        before do
          @invitation.invited_member.stub(:valid?) { true }
          @invitation.invited_member.stub(:update_attributes)
          @invitation.stub(:claim!)
        end

        it_behaves_like 'success'

        it 'claims the invitation' do
          @invitation.invited_member.stub(:update_attributes)
          @invitation.should_receive(:claim!)
          do_request
        end
      end

      context 'user attributes are not valid' do
        before do
          @invitation.invited_member.stub(:update_attributes)
          @invitation.stub(:claim!)
          @invitation.invited_member.stub(:valid?) { false }
        end

        it_behaves_like 'failure'

        it 'doesn\'t claim the invitation' do
          @invitation.should_not_receive(:claim!)
          do_request
        end
      end
    end
  end
end
