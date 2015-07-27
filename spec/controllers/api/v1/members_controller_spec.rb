require 'spec_helper'
require 'stripe_mock'

describe Api::V1::MembersController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:results) { [user] }

  before do
    controller.stub(current_ability: ability)
    Member.stub(find: user)
  end

  describe 'GET index' do
    def do_request(params={})
      get :index, params
    end

    before do
      Member.stub_chain(:page, :per).and_return(results)
      results.stub(total_count: 1)
      results.stub(:includes).and_return(results)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of members as users' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:users].to_json.should == [user].serializer(list: true).as_json.to_json
      end

      context 'with a query param' do
        it 'searches by name and returns an array of members as users' do
          Member.should_receive(:name_search).once.and_return(Member)
          do_request(q: user.first_name)
          body = JSON.parse(response.body, symbolize_names: true)
          body[:users].to_json.should == [user].serializer(list: true).as_json.to_json
        end
      end

      context 'with a pha_id param' do
        it 'searches by pha_id' do
          Member.stub(:name_search).and_return(Member)
          Member.stub(:signed_up).and_return(Member)
          Member.should_receive(:where).with('pha_id' => '1').once.and_return(Member)
          do_request(q: user.first_name, pha_id: 1)
          body = JSON.parse(response.body, symbolize_names: true)
          body[:users].to_json.should == [user].serializer(list: true).as_json.to_json
        end
      end
    end
  end

  describe 'PUT secure_update' do
    def do_request
      put :secure_update, user: attributes_for(:user).merge!(current_password: 'password')
    end

    before do
      request.env['PATH_INFO'] = 'controller_path'
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      before do
        controller.stub(login: false)
      end

      it_behaves_like 'failure'

      context 'password authenticated' do
        before do
          controller.stub(login: user)
        end

        it_behaves_like 'action requiring authorization'

        context 'authorized', user: :authorize! do
          it 'attempts to update the record' do
            user.should_receive(:update_attributes).once
            do_request
          end

          context 'update_attributes succeeds' do
            before do
              user.stub(update_attributes: true)
            end

            it_behaves_like 'success'
          end

          context 'update_attributes fails' do
            before do
              user.stub(update_attributes: false)
              user.errors.add(:base, :invalid)
            end

            it_behaves_like 'failure'
          end
        end
      end
    end
  end
end
