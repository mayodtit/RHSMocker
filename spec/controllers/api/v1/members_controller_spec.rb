require 'spec_helper'

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
      get :index, {auth_token: user.auth_token}.merge!(params)
    end

    before do
      Member.stub_chain(:page, :per).and_return(results)
      results.stub(total_count: 1)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of members as users' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:users].to_json.should == [user].serializer.as_json.to_json
      end

      context 'with a query param' do
        it 'searches by name and returns an array of members as users' do
          Member.should_receive(:name_search).once.and_return(Member)
          do_request(q: user.first_name)
          body = JSON.parse(response.body, symbolize_names: true)
          body[:users].to_json.should == [user].serializer.as_json.to_json
        end
      end

      context 'with a pha_id param' do
        it 'searches by pha_id' do
          Member.stub(:name_search).and_return(Member)
          Member.should_receive(:where).with('pha_id' => '1').once.and_return(Member)
          do_request(q: user.first_name, pha_id: 1)
          body = JSON.parse(response.body, symbolize_names: true)
          body[:users].to_json.should == [user].serializer.as_json.to_json
        end
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the member' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:user].to_json.should == user.serializer.as_json.to_json
      end
    end
  end

  describe 'GET current' do
    def do_request
      get :current
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it_behaves_like 'success'

      it 'returns the current_user' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:user].to_json.should == user.serializer(include_roles: true).as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, user: attributes_for(:member)
    end

    before do
      Member.stub(create: user)
    end

    it 'attempts to create the record' do
      Member.should_receive(:create).once
      do_request
    end

    context 'save succeeds' do
      it_behaves_like 'success'

      it 'returns the member' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:user].to_json.should == user.serializer.as_json.to_json
      end

      it "returns the member's auth_token" do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:auth_token].to_json.should == user.auth_token.as_json.to_json
      end
    end

    context 'save fails' do
      before do
        user.errors.add(:base, :invalid)
      end

      it_behaves_like 'failure'
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, user: attributes_for(:user)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to update the record' do
        user.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before do
          user.stub(update_attributes: true)
        end

        it_behaves_like 'success'

        it 'returns the member' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          body[:user].to_json.should == user.serializer.as_json.to_json
        end
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
