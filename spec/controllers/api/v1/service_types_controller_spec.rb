require 'spec_helper'

describe Api::V1::ServiceTypesController do
  let(:user) { build_stubbed :pha }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      let(:service_types) { [build_stubbed(:service_type), build_stubbed(:service_type)] }

      it_behaves_like 'success'

      it 'returns all service types' do
        ServiceType.should_receive(:order).with('name ASC') { service_types }
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:service_types].to_json.should == service_types.serializer.as_json.to_json
      end
    end
  end
end
