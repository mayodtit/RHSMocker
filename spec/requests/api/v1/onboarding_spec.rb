require 'spec_helper'

describe 'Onboarding' do
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
        let!(:onboarding_group) { create(:onboarding_group, skip_credit_card: true) }
        let!(:referral_code) { create(:referral_code, onboarding_group: onboarding_group) }

        it 'returns skip_credit_card' do
          do_request(code: referral_code.code)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:skip_credit_card]).to be_true
        end
      end

      context 'that does not skip credit cards' do
        let(:onboarding_group) { create(:onboarding_group) }
        let(:referral_code) { create(:referral_code, onboarding_group: onboarding_group) }

        it 'returns skip_credit_card=false' do
          do_request(code: referral_code.code)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:skip_credit_card]).to be_false
        end
      end
    end
  end
end
