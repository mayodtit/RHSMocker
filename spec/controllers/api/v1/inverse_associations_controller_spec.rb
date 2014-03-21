require 'spec_helper'

describe Api::V1::InverseAssociationsController do
  let(:user) { build_stubbed(:member) }
  let(:association) { build_stubbed(:association, associate: user) }
  let(:associations) { [association] }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
    User.stub(find: user)
    user.stub_chain(:inverse_associations, :enabled_or_pending, :includes).and_return(associations)
    associations.stub(find: association)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the associations' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:associations].to_json).to eq([association].serializer.as_json.to_json)
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, association: attributes_for(:association)
    end

    before do
      association.stub(:update_attributes)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to update the record' do
        association.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before do
          association.stub(update_attributes: true)
        end

        it_behaves_like 'success'

        it 'returns the association' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:association].to_json).to eq(association.serializer.as_json.to_json)
        end
      end

      context 'update_attributes fails' do
        before do
          association.stub(update_attributes: false)
          association.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'DELETE destroy' do
    def do_request
      delete :destroy
    end

    before do
      association.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        association.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before do
          association.stub(destroy: true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before do
          association.stub(destroy: false)
          association.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
