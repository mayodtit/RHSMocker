require 'spec_helper'

describe Api::V1::RolesController do
  let(:user) { build_stubbed(:pha_lead) }
  let(:role) { build_stubbed(:role) }
  let(:member) { build_stubbed(:user) }

  let(:ability) { Object.new.extend(CanCan::Ability) }
  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET members' do
    def do_request
      get :members, auth_token: user.auth_token, role_name: 'pha'
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      context 'role doesn\'t exist' do
        before do
          Role.stub(:find_by_name!).with('pha') { raise(ActiveRecord::RecordNotFound) }
        end

        it_behaves_like '404'
      end

      context 'role exists' do
        before do
          Role.stub(:find_by_name!).with('pha') { role }
        end

        it 'returns all members with role' do
          members = [ member ]
          User.should_receive(:with_role).with(role.name) {
            o = Object.new
            o.should_receive(:find_all_by_type).with('Member') {
              members
            }
            o
          }

          members.should_receive(:as_json).with(
            only: [:id, :first_name, :last_name, :email],
            methods: [:full_name]
          )

          do_request

          response.should be_success
        end
      end
    end
  end
end