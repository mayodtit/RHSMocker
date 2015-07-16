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
        expect(body[:onboarding_custom_welcome]).to eq(onboarding_group.serializer(onboarding_custom_welcome: true).as_json)
      end
    end

    context 'user does not exist' do
      it 'returns requires_sign_up=true and customizations' do
        do_request(email: 'test@getbetter.com')
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:requires_sign_up]).to be_true
        expect(body[:onboarding_customization]).to be_nil # not currently supported
        expect(body[:onboarding_custom_welcome]).to be_nil # not currently supported
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

  describe '#log_in' do
    def do_request(params={})
      post '/api/v1/onboarding/log_in', params
    end

    context 'bad credentials' do
      it 'returns 401' do
        do_request(email: 'test@getbetter.com', password: 'baadbeef')
        expect(response).to_not be_success
        expect(response.code).to eq('401')
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:reason]).to eq('Incorrect credentials')
        expect(body[:user_message]).to eq('Email or password is invalid')
      end
    end

    context 'good credentials' do
      let(:email) { 'test@getbetter.com' }
      let(:password) { 'password' }

      context 'normal user' do
        let!(:pha) { create(:pha) }
        let!(:onboarding_group) { create(:onboarding_group, custom_welcome: 'lorem ipsum') }
        let!(:user) { create(:member, :premium, email: email, password: password, pha: pha, onboarding_group: onboarding_group) }

        it 'creates a new session and returns the log in information' do
          expect{ do_request(email: email, password: password) }.to change(Session, :count).by(1)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:user].to_json).to eq(user.serializer(include_roles: true).as_json.to_json)
          expect(body[:pha].to_json).to eq(pha.serializer.as_json.to_json)
          expect(body[:auth_token]).to be_present
          expect(body[:onboarding_custom_welcome]).to eq(onboarding_group.serializer(onboarding_custom_welcome: true).as_json)
        end
      end

      context 'care portal user' do
        let!(:user) { create(:pha, email: email, password: password) }

        it 'creates a new care portal session and returns the log in information' do
          expect{ do_request(email: email, password: password, care_portal: true) }.to change(CarePortalSession, :count).by(1)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:user].to_json).to eq(user.serializer(include_roles: true).as_json.to_json)
          expect(body[:auth_token]).to be_present
        end
      end
    end
  end
end
