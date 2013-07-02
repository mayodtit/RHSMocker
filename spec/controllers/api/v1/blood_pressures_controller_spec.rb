require 'spec_helper'

describe Api::V1::BloodPressuresController do
  let(:user) { build(:user) }
  let(:blood_pressure) { build(:blood_pressure, :user => user) }

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
          controller.stub(:authorize!)
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

  describe 'POST create'
  describe 'delete destroy'
end
