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

    # TODO - make this more sensible; we should be intercepting an exception here.
    it 'requires authentication' do
      do_request
      response.should_not be_success
      json = JSON.parse(response.body)
      json['reason'].should == "Invalid auth_token"
    end

    context 'user signed-in' do
      before(:each) do
        controller.stub(:authentication_check)
        controller.stub(:current_user => user)
      end

      it 'requires User authorization' do
        expect{ do_request }.to raise_error(CanCan::AccessDenied)
      end

      context 'authorized' do
        before(:each) do
          ability.can :manage, User
        end

        it 'is successful' do
          do_request
          response.should be_success
        end

        it 'returns an array of user diseases' do
          do_request
          json = JSON.parse(response.body)
          json['user_diseases'].to_json.should == [user_disease.as_json].to_json
        end
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

    # TODO - make this more sensible; we should be intercepting an exception here.
    it 'requires authentication' do
      do_request
      response.should_not be_success
      json = JSON.parse(response.body)
      json['reason'].should == "Invalid auth_token"
    end

    context 'user signed-in' do
      before(:each) do
        controller.stub(:authentication_check)
        controller.stub(:current_user => user)
      end

      it 'requires User authorization' do
        expect{ do_request }.to raise_error(CanCan::AccessDenied)
      end

      context 'authorized' do
        before(:each) do
          ability.can :manage, User
          ability.can :manage, UserDisease
        end

        it 'is successful' do
          do_request
          response.should be_success
        end

        it 'returns the user diseases' do
          do_request
          json = JSON.parse(response.body)
          json['user_disease'].to_json.should == user_disease.as_json.to_json
        end
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

    it 'requires authentication' do
      do_request
      response.should_not be_success
      json = JSON.parse(response.body)
      json['reason'].should == "Invalid auth_token"
    end

    context 'user signed-in' do
      before(:each) do
        controller.stub(:authentication_check)
        controller.stub(:current_user => user)
      end

      it 'requires User authorization' do
        expect{ do_request }.to raise_error(CanCan::AccessDenied)
      end

      context 'authorized' do
        before(:each) do
          ability.can :manage, User
        end

        it 'attempts to create the record' do
          user_diseases.should_receive(:create).once
          do_request
        end

        context 'save succeeds' do
          it 'returns success' do
            do_request
            response.should be_success
          end

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

          it 'returns failure' do
            do_request
            response.should_not be_success
          end
        end
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

    it 'requires authentication' do
      do_request
      response.should_not be_success
      json = JSON.parse(response.body)
      json['reason'].should == "Invalid auth_token"
    end

    context 'user signed-in' do
      before(:each) do
        controller.stub(:authentication_check)
        controller.stub(:current_user => user)
      end

      it 'requires User authorization' do
        expect{ do_request }.to raise_error(CanCan::AccessDenied)
      end

      context 'authorized' do
        before(:each) do
          ability.can :manage, User
          ability.can :manage, UserDisease
        end

        it 'attempts to update the record' do
          user_disease.should_receive(:update_attributes).once
          do_request
        end

        context 'update_attributes succeeds' do
          before(:each) do
            user_disease.stub(:update_attributes => true)
          end

          it 'returns success' do
            do_request
            response.should be_success
          end
        end

        context 'update_attributes fails' do
          before(:each) do
            user_disease.stub(:update_attributes => false)
            user_disease.errors.add(:base, :invalid)
          end

          it 'returns failure' do
            do_request
            response.should_not be_success
          end
        end
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

    it 'requires authentication' do
      do_request
      response.should_not be_success
      json = JSON.parse(response.body)
      json['reason'].should == "Invalid auth_token"
    end

    context 'user signed-in' do
      before(:each) do
        controller.stub(:authentication_check)
        controller.stub(:current_user => user)
      end

      it 'requires User authorization' do
        expect{ do_request }.to raise_error(CanCan::AccessDenied)
      end

      context 'authorized' do
        before(:each) do
          ability.can :manage, User
          ability.can :manage, UserDisease
        end

        it 'attempts to destroy the record' do
          user_disease.should_receive(:destroy).once
          do_request
        end

        context 'destroy succeeds' do
          before(:each) do
            user_disease.stub(:destroy => true)
          end

          it 'returns success' do
            do_request
            response.should be_success
          end
        end

        context 'destroy fails' do
          before(:each) do
            user_disease.stub(:destroy => false)
            user_disease.errors.add(:base, :invalid)
          end

          it 'returns failure' do
            do_request
            response.should_not be_success
          end
        end
      end
    end
  end
end
