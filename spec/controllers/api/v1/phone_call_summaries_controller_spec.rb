require 'spec_helper'

describe Api::V1::PhoneCallSummariesController do
  let(:phone_call_summary) { build_stubbed(:phone_call_summary) }
  let(:user) { phone_call_summary.callee }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
    PhoneCallSummary.stub(:find => phone_call_summary)
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the phone_call_summary' do
        do_request
        json = JSON.parse(response.body, :symbolize_names => true)
        json[:phone_call_summary][:id].should == phone_call_summary.as_json['id']
      end
    end
  end
end
