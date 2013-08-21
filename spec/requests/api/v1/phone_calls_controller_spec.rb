require 'spec_helper'

describe 'PhoneCall' do
  let(:user) { create(:member) }
  let(:consult) { create(:consult, :initiator => user) }

  before(:each) do
    user.login
  end

  context 'existing record' do
    let!(:phone_call) { create(:phone_call) }
    let!(:message) { create(:message, :user => user,
                                      :consult => consult,
                                      :phone_call => phone_call) }
    let(:id) { phone_call.id }

    describe 'GET /api/v1/consults/:consult_id/phone_calls' do
      def do_request(params={})
        get "/api/v1/consults/#{consult.id}/phone_calls", params.merge!(auth_token: user.auth_token)
      end

      it 'indexes the phone_calls for this consult' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:phone_calls].to_json.should == [phone_call].as_json.to_json
      end
    end

    describe 'GET /api/v1/consults/:consult_id/phone_calls/:id' do
      def do_request(params={})
        get "/api/v1/consults/#{consult.id}/phone_calls/#{id}", params.merge!(auth_token: user.auth_token)
      end

      it 'shows the phone_call' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:phone_call].to_json.should == phone_call.as_json.to_json
      end
    end
  end

  context 'creating a record' do
    describe 'POST /api/v1/consults/:consult_id/phone_calls' do
      def do_request(params={})
        post "/api/v1/consults/#{consult.id}/phone_calls", {auth_token: user.auth_token}.merge!(:phone_call => attributes)
      end

      let(:attributes) { attributes_for(:phone_call) }

      it 'creates a new phone_call' do
        expect{ do_request(attributes) }.to change(PhoneCall, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        PhoneCall.find(body[:phone_call][:id]).should_not be_nil
      end

      it 'creates a message for the consult' do
        expect{ do_request }.to change(PhoneCall, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        spc = PhoneCall.find(body[:phone_call][:id])
        spc.consult.should == consult
        consult.messages.should include(spc.message)
      end
    end
  end
end
