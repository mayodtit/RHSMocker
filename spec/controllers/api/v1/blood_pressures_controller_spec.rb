require 'spec_helper'

describe Api::V1::BloodPressuresController do
  let(:user) { build(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:blood_pressure) { build(:blood_pressure, :user => user) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      user.stub(:blood_pressures => [blood_pressure])
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

        it 'returns an array of user blood pressures' do
          do_request
          json = JSON.parse(response.body)
          json['blood_pressures'].to_json.should == [blood_pressure.as_json].to_json
        end
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, blood_pressure: blood_pressure.as_json
    end

    let(:blood_pressures) { double('blood_pressures', :create => blood_pressure) }

    before(:each) do
      user.stub(:blood_pressures => blood_pressures)
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
          blood_pressures.should_receive(:create).once
          do_request
        end

        context 'save succeeds' do
          it 'returns success' do
            do_request
            response.should be_success
          end

          it 'returns the blood pressure' do
            do_request
            json = JSON.parse(response.body)
            json['blood_pressure'].to_json.should == blood_pressure.as_json.to_json
          end
        end

        context 'save fails' do
          before(:each) do
            blood_pressure.errors.add(:base, :invalid)
          end

          it 'returns failure' do
            do_request
            response.should_not be_success
          end
        end
      end
    end
  end

  describe 'delete destroy' do
    def do_request
      delete :destroy
    end

    before(:each) do
      BloodPressure.stub(:find => blood_pressure)
      blood_pressure.stub(:destroy)
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
          ability.can :manage, BloodPressure
        end

        it 'attempts to destroy the record' do
          blood_pressure.should_receive(:destroy).once
          do_request
        end

        context 'destroy succeeds' do
          before(:each) do
            blood_pressure.stub(:destroy => true)
          end

          it 'returns success' do
            do_request
            response.should be_success
          end
        end

        context 'destroy fails' do
          before(:each) do
            blood_pressure.stub(:destroy => false)
            blood_pressure.errors.add(:base, :invalid)
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
