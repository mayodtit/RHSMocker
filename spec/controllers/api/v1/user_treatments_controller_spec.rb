require 'spec_helper'

describe Api::V1::UserTreatmentsController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:user_disease_treatment) { build_stubbed(:user_disease_treatment, :user => user) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      user.stub(:user_disease_treatments => [user_disease_treatment])
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of user diseases' do
        do_request
        json = JSON.parse(response.body)
        json['user_treatments'].to_json.should == [user_disease_treatment.as_json].to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    let(:user_disease_treatments) { double('user_disease_treatments', :find => user_disease_treatment) }

    before(:each) do
      user.stub(:user_disease_treatments => user_disease_treatments)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the user diseases' do
        do_request
        json = JSON.parse(response.body)
        json['user_treatment'].to_json.should == user_disease_treatment.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, user_disease_treatment: user_disease_treatment.as_json
    end

    let(:user_disease_treatments) { double('user_disease_treatments', :create => user_disease_treatment) }

    before(:each) do
      user.stub(:user_disease_treatments => user_disease_treatments)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        user_disease_treatments.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the user disease' do
          do_request
          json = JSON.parse(response.body)
          json['user_treatment'].to_json.should == user_disease_treatment.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          user_disease_treatment.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, user_disease_treatment: attributes_for(:user_disease_treatment)
    end

    let(:user_disease_treatments) { double('user_disease_treatments', :find => user_disease_treatment) }

    before(:each) do
      user.stub(:user_disease_treatments => user_disease_treatments)
      user_disease_treatment.stub(:update_attributes)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to update the record' do
        user_disease_treatment.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before(:each) do
          user_disease_treatment.stub(:update_attributes => true)
        end

        it_behaves_like 'success'
      end

      context 'update_attributes fails' do
        before(:each) do
          user_disease_treatment.stub(:update_attributes => false)
          user_disease_treatment.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'DELETE destroy' do
    def do_request
      delete :destroy
    end

    let(:user_disease_treatments) { double('user_disease_treatments', :find => user_disease_treatment) }

    before(:each) do
      user.stub(:user_disease_treatments => user_disease_treatments)
      user_disease_treatment.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        user_disease_treatment.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before(:each) do
          user_disease_treatment.stub(:destroy => true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before(:each) do
          user_disease_treatment.stub(:destroy => false)
          user_disease_treatment.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
