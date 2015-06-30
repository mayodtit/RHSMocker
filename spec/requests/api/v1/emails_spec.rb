require 'spec_helper'

describe 'Emails' do
  describe 'GET /api/v1/emails' do
    def do_request(params={})
      get '/api/v1/emails', params
    end

    context 'email exists' do
      let!(:member) { create(:member, :premium) }

      it 'returns exists=true' do
        do_request(email: member.email)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:exists]).to be_true
      end

      context 'with an onboarding_group' do
        let!(:onboarding_group) { create(:onboarding_group) }

        before do
          member.update_attributes(onboarding_group: onboarding_group)
        end

        it 'returns exists=true and the onboarding group' do
          do_request(email: member.email)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:exists]).to be_true
          expect(body[:onboarding_group].to_json).to eq(onboarding_group.serializer(for_onboarding: true).as_json.to_json)
        end
      end
    end

    context 'email does not exist' do
      it 'returns exists=false' do
        do_request(email: 'bademail@getbetter.com')
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:exists]).to be_false
      end
    end
  end
end