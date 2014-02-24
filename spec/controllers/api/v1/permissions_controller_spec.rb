require 'spec_helper'

describe Api::V1::PermissionsController do
  let(:user) { build_stubbed(:admin) }
  let(:permission) { build_stubbed(:permission) }
  let(:association) { permission.subject }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
    Association.stub(find: association)
    association.stub(permission: permission)
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the permission' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:permission].to_json.should == permission.serializer.as_json.to_json
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, permission: {level: :edit}
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
end
