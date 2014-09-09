require 'spec_helper'

describe Api::V1::BloodPressuresController do
  let(:user) { build_stubbed(:member) }
  let(:session) { user.sessions.build }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:blood_pressure) { build_stubbed(:blood_pressure, :user => user) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: session.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'index action', new.blood_pressure
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

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        blood_pressures.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

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

        it_behaves_like 'failure'
      end
    end
  end

  describe 'delete destroy' do
    def do_request
      delete :destroy
    end

    let(:blood_pressures) { double('blood_pressures', :find => blood_pressure) }

    before(:each) do
      user.stub(:blood_pressures => blood_pressures)
      blood_pressure.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        blood_pressure.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before(:each) do
          blood_pressure.stub(:destroy => true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before(:each) do
          blood_pressure.stub(:destroy => false)
          blood_pressure.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
