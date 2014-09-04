require 'spec_helper'

describe Api::V1::UserAllergiesController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:user_allergy) { build_stubbed(:user_allergy, :user => user) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'index action', new.user_allergy
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    let(:user_allergies) { double('user_allergies', :find => user_allergy) }

    before(:each) do
      user.stub(:user_allergies => user_allergies)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the user allergies' do
        do_request
        json = JSON.parse(response.body)
        json['user_allergy'].to_json.should == user_allergy.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, user_allergy: user_allergy.as_json
    end

    let(:user_allergies) { double('user_allergies', :create => user_allergy) }

    before(:each) do
      user.stub(:user_allergies => user_allergies)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        user_allergies.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the blood pressure' do
          do_request
          json = JSON.parse(response.body)
          json['user_allergy'].to_json.should == user_allergy.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          user_allergy.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'delete destroy' do
    def do_request
      delete :destroy
    end

    let(:user_allergies) { double('user_allergies', :find => user_allergy) }

    before(:each) do
      user.stub(:user_allergies => user_allergies)
      user_allergy.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        user_allergy.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before(:each) do
          user_allergy.stub(:destroy => true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before(:each) do
          user_allergy.stub(:destroy => false)
          user_allergy.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
