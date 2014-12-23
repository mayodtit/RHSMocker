require 'spec_helper'

describe Api::V1::AssociationsController do
  let(:user) { build_stubbed(:member) }
  let(:association) { build_stubbed(:association, user: user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
    user.stub_chain(:associations, :enabled, :includes).and_return([association])
    user.stub_chain(:associations, :find).and_return(association)
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
        body[:associations].to_json.should == [association].serializer(scope: user).as_json.to_json
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

      it 'returns the association' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:association].to_json.should == association.serializer(scope: user).as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, association: attributes_for(:association)
    end

    let(:associations) { double('associations', create: association) }

    before do
      user.stub(associations: associations)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to create the record' do
        associations.should_receive(:create).once
        do_request
      end

      it 'sets the creator id' do
        associations.should_receive(:create).with hash_including(creator_id: user.id)
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the association' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          body[:association].to_json.should == association.serializer(scope: user).as_json.to_json
        end
      end

      context 'save fails' do
        before do
          association.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
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

        it 'returns the associate' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          body[:association].to_json.should == association.serializer(scope: user).as_json.to_json
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

      it 'sets the actor id' do
        association.should_receive(:actor_id=).with(user.id)
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

  describe 'POST invite' do
    def do_request
      post :invite
    end

    before do
      association.stub(:invite!)
      association.stub(pair: build_stubbed(:association))
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'calls invite! on the association' do
        association.should_receive(:invite!).once
        do_request
      end

      it_behaves_like 'success'
    end
  end
end
