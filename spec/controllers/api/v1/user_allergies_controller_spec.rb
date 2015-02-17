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

    before(:each) do
      user.stub(:user_allergies => [user_allergy])
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the user allergies' do
        do_request
        json = JSON.parse(response.body)
        json['user_allergies'][0]['allergy_id'] == user_allergy.allergy_id
        json['user_allergies'][0]['allergy'] == user_allergy.allergy.as_json.to_json
      end
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

      it 'returns the user allergy' do
        do_request
        json = JSON.parse(response.body)
        json['user_allergy']['allergy_id'] == user_allergy.allergy_id
        json['user_allergy']['allergy'] == user_allergy.allergy.as_json.to_json
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
      user_allergy.stub(:reload)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        user_allergies.should_receive(:create).once
        do_request
      end

      it 'sets the actor id' do
        user_allergies.should_receive(:create).with hash_including(actor_id: user.id)
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the allergy here' do
          do_request
          json = JSON.parse(response.body)
          json['user_allergy']['allergy_id'] == user_allergy.allergy_id
          json['user_allergy']['allergy'] == user_allergy.allergy.as_json.to_json
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

  describe 'DELETE destroy' do
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

      it 'sets the actor id' do
        user_allergy.should_receive(:actor_id=).with(user.id)
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
