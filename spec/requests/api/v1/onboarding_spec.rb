require 'spec_helper'

describe 'Onboarding' do
  describe '#email_validation' do
    def do_request(params={})
      get '/api/v1/onboarding/email_validation', params
    end

    context 'user exists' do
      let!(:onboarding_group) { create(:onboarding_group, custom_welcome: 'lorem ipsum') }
      let!(:user) { create(:member, :premium, email: 'test@getbetter.com', onboarding_group: onboarding_group) }

      it 'returns requires_sign_up=false and customizations' do
        do_request(email: user.email)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:requires_sign_up]).to be_false
        expect(body[:onboarding_customization]).to eq(onboarding_group.serializer(onboarding_customization: true).as_json)
      end
    end

    context 'user does not exist' do
      it 'returns requires_sign_up=true and customizations' do
        do_request(email: 'test@getbetter.com')
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:requires_sign_up]).to be_true
        expect(body[:onboarding_customization]).to be_nil # not currently supported
      end
    end
  end

  describe '#referral_code_validation' do
    def do_request(params={})
      get '/api/v1/onboarding/referral_code_validation', params
    end

    context 'invalid code' do
      it 'returns 404' do
        do_request(code: 'baadbeef')
        expect(response).to_not be_success
        expect(response.code).to eq('404')
      end
    end

    context 'with an onboarding group' do
      context 'that skips credit cards' do
        let!(:onboarding_group) { create(:onboarding_group, skip_credit_card: true, custom_welcome: 'lorem ipsum') }
        let!(:referral_code) { create(:referral_code, onboarding_group: onboarding_group) }

        it 'returns skip_credit_card and custom welcome' do
          do_request(code: referral_code.code)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:skip_credit_card]).to be_true
          expect(body[:onboarding_custom_welcome]).to eq(onboarding_group.serializer(onboarding_custom_welcome: true).as_json)
        end
      end

      context 'that does not skip credit cards' do
        let(:onboarding_group) { create(:onboarding_group) }
        let(:referral_code) { create(:referral_code, onboarding_group: onboarding_group) }

        it 'returns skip_credit_card=false and custom welcome' do
          do_request(code: referral_code.code)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:skip_credit_card]).to be_false
          expect(body[:onbaording_custom_welcome]).to be_nil # not currently supported
        end
      end
    end
  end
end
