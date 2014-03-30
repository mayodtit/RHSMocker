require 'spec_helper'

describe 'Associations' do
  let!(:user) { create(:member) }
  let!(:consult) { create(:consult, initiator: user) }

  describe 'POST /api/v1/consults/:consult_id/phone_calls' do
    def do_request(params={})
      post "/api/v1/consults/#{consult.id}/phone_calls", params.merge!(auth_token: user.auth_token)
    end

    it 'creates a phone call' do
      expect{ do_request(phone_call: {destination_phone_number: '5555555555'}) }.to change(PhoneCall, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      phone_call = PhoneCall.find(body[:phone_call][:id])
      expect(body[:phone_call].to_json).to eq(phone_call.serializer.as_json.to_json)
      expect(phone_call.user).to eq(user)
      expect(phone_call.consult).to eq(consult)
    end
  end
end
