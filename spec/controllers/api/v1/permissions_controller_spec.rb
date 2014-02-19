require 'spec_helper'

describe Api::V1::PermissionsController do
  let(:user) { build_stubbed(:admin) }
  let(:permission) { build_stubbed(:permission) }
  let(:association) { permission.subject }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
    Association.stub(find: association)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    before do
      association.stub(:permissions).and_return([permission])
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it "returns an array of Permissions" do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:permissions].to_json).to eq([permission].as_json.to_json)
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, permission: attributes_for(:permission)
    end

    let(:permissions) { double('permissions', create: permission) }

    before do
      association.stub(permissions: permissions)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to create the record' do
        permissions.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the permission' do
          do_request
          json = JSON.parse(response.body)
          json['permission'].to_json.should == permission.as_json.to_json
        end
      end

      context 'save fails' do
        before do
          permission.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, permission: {level: :edit}
    end

    let(:permissions) { double('permissions', find: permission) }

    before do
      association.stub(permissions: permissions)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to update the record' do
        permission.should_receive(:update_attributes).once
        do_request
      end

      context 'update succeeds' do
        before do
          permission.stub(update_attributes: true)
        end

        it_behaves_like 'success'
      end

      context 'update fails' do
        before do
          permission.stub(update_attributes: false)
          permission.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'DELETE destroy' do
    def do_request
      delete :destroy
    end

    let(:permissions) { double('permissions', find: permission) }

    before do
      association.stub(permissions: permissions)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        permission.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before do
          permission.stub(destroy: true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before do
          permission.stub(destroy: false)
          permission.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
