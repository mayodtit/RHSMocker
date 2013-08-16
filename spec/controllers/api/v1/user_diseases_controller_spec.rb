require 'spec_helper'

describe Api::V1::UserDiseasesController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:user_disease) { build_stubbed(:user_disease, :user => user) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      user.stub(:user_diseases => [user_disease])
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of user diseases' do
        do_request
        json = JSON.parse(response.body)
        json['user_diseases'].to_json.should == [user_disease.as_json].to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    let(:user_diseases) { double('user_diseases', :find => user_disease) }

    before(:each) do
      user.stub(:user_diseases => user_diseases)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the user diseases' do
        do_request
        json = JSON.parse(response.body)
        json['user_disease'].to_json.should == user_disease.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, user_disease: user_disease.as_json
    end

    let(:user_diseases) { double('user_diseases', :create => user_disease) }

    before(:each) do
      user.stub(:user_diseases => user_diseases)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        user_diseases.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the user disease' do
          do_request
          json = JSON.parse(response.body)
          json['user_disease'].to_json.should == user_disease.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          user_disease.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update
    end

    let(:user_diseases) { double('user_diseases', :find => user_disease) }

    before(:each) do
      user.stub(:user_diseases => user_diseases)
      user_disease.stub(:update_attributes)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to update the record' do
        user_disease.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before(:each) do
          user_disease.stub(:update_attributes => true)
        end

        it_behaves_like 'success'
      end

      context 'update_attributes fails' do
        before(:each) do
          user_disease.stub(:update_attributes => false)
          user_disease.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'DELETE destroy' do
    def do_request
      delete :destroy
    end

    let(:user_diseases) { double('user_diseases', :find => user_disease) }

    before(:each) do
      user.stub(:user_diseases => user_diseases)
      user_disease.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        user_disease.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before(:each) do
          user_disease.stub(:destroy => true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before(:each) do
          user_disease.stub(:destroy => false)
          user_disease.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
