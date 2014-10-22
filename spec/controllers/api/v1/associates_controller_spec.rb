require 'spec_helper'

describe Api::V1::AssociatesController do
  let(:user) { build_stubbed(:member) }
  let(:associate) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
    User.stub(find: user)
    user.stub(associates: [associate])
    user.stub_chain(:associates, :find).and_return(associate)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the associates' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:users].to_json.should == [associate].serializer.as_json.to_json
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

      it 'returns the associate' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:user].to_json.should == associate.serializer.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, user: attributes_for(:user)
    end

    let(:associates) { double('associates', create: associate) }

    before do
      user.stub(associates: associates)
      associate.stub(:reload)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to create the record' do
        associates.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the associate' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          body[:user].to_json.should == associate.serializer.as_json.to_json
        end
      end

      context 'save fails' do
        before do
          associate.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, user: attributes_for(:user)
    end

    before do
      associate.stub(:update_attributes)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to update the record' do
        associate.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before do
          associate.stub(update_attributes: true)
        end

        it_behaves_like 'success'

        it 'returns the associate' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          body[:user].to_json.should == associate.serializer.as_json.to_json
        end
      end

      context 'update_attributes fails' do
        before do
          associate.stub(update_attributes: false)
          associate.errors.add(:base, :invalid)
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
      associate.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        associate.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before do
          associate.stub(destroy: true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before do
          associate.stub(destroy: false)
          associate.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
