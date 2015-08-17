require 'spec_helper'
require 'stripe_mock'

describe 'Onboarding' do
  describe '#email_validation' do
    def do_request(params={})
      get '/api/v1/onboarding/email_validation', params
    end

    context 'user exists' do
      let!(:onboarding_group) { create(:onboarding_group, skip_credit_card: true, custom_welcome: 'lorem ipsum') }
      let!(:user) { create(:member, :premium, email: 'test@getbetter.com', onboarding_group: onboarding_group, first_name: 'Kyle') }

      before do
        CarrierWave::Mount::Mounter.any_instance.stub(:store!)
        onboarding_group.update_attributes!(header_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')),
                                            background_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')))
      end

      it 'returns requires_sign_up=false and customizations' do
        do_request(email: user.email)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        reloaded_onboarding_group = OnboardingGroup.find(onboarding_group.id)
        expect(body[:requires_sign_up]).to be_false
        expect(body[:skip_credit_card]).to be_true
        expect(body[:user]).to eq({first_name: user.first_name})
        expect(body[:onboarding_customization]).to eq(reloaded_onboarding_group.serializer(onboarding_customization: true).as_json)
        expect(body[:onboarding_custom_welcome]).to eq([reloaded_onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
      end

      context 'user has logged in previously' do
        let!(:previous_session) { create(:session, member: user) }

        it "doesn't return the onboarding_custom_welcome" do
          do_request(email: user.email)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:onboarding_custom_welcome]).to be_empty
        end
      end
    end

    context 'user does not exist' do
      context 'email is invalid' do
        let(:email) { 'bademail@g3t.b3**3%.com' }

        it 'returns 422 and an error response' do
          do_request(email: email)
          expect(response).to_not be_success
          expect(response.code).to eq('422')
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:reason]).to eq('Email is invalid')
        end
      end

      context 'email is valid' do
        let(:email) { 'test@getbetter.com' }

        it 'returns requires_sign_up=true and customizations' do
          do_request(email: email)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:requires_sign_up]).to be_true
          expect(body[:skip_credit_card]).to be_false
          expect(body[:user]).to be_nil
          expect(body[:onboarding_customization]).to be_nil
          expect(body[:onboarding_custom_welcome]).to be_empty
        end

        context 'with customizations' do
          let!(:onboarding_group) { create(:onboarding_group, custom_welcome: 'lorem ipsum', skip_credit_card: true) }
          let!(:onboarding_group_candidate) { create(:onboarding_group_candidate, onboarding_group: onboarding_group, first_name: 'Kyle') }

          before do
            CarrierWave::Mount::Mounter.any_instance.stub(:store!)
            onboarding_group.update_attributes!(header_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')),
                                                background_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')))
          end

          it 'returns requires_sign_up=true and customizations' do
            do_request(email: onboarding_group_candidate.email)
            expect(response).to be_success
            body = JSON.parse(response.body, symbolize_names: true)
            reloaded_onboarding_group = OnboardingGroup.find(onboarding_group.id)
            expect(body[:requires_sign_up]).to be_true
            expect(body[:skip_credit_card]).to be_true
            expect(body[:user]).to eq({first_name: onboarding_group_candidate.first_name})
            expect(body[:onboarding_customization]).to eq(reloaded_onboarding_group.serializer(onboarding_customization: true).as_json)
            expect(body[:onboarding_custom_welcome]).to eq([reloaded_onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
          end
        end
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

        before do
          CarrierWave::Mount::Mounter.any_instance.stub(:store!)
          onboarding_group.update_attributes!(header_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')),
                                              background_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')))
        end

        it 'returns skip_credit_card and custom welcome' do
          do_request(code: referral_code.code)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          reloaded_onboarding_group = OnboardingGroup.find(onboarding_group.id)
          expect(body[:skip_credit_card]).to be_true
          expect(body[:onboarding_custom_welcome]).to eq([reloaded_onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
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
        let!(:suggested_service) { create(:suggested_service, user: user) }
        let(:suggested_services_modal) do
          {
            header_text: 'To get started with a Personal Health Assistant, please select a Service.',
            suggested_services: [suggested_service.serializer.as_json],
            action_button_text: "LET'S GO!"
          }
        end

        before do
          CarrierWave::Mount::Mounter.any_instance.stub(:store!)
          onboarding_group.update_attributes!(header_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')),
                                              background_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')))
        end

        it 'creates a new session and returns the log in information' do
          expect{ do_request(email: email, password: password) }.to change(Session, :count).by(1)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          reloaded_onboarding_group = OnboardingGroup.find(onboarding_group.id)
          expect(body[:user].to_json).to eq(user.serializer(include_roles: true).as_json.to_json)
          expect(body[:pha].to_json).to eq(pha.serializer.as_json.to_json)
          expect(body[:auth_token]).to be_present
          expect(body[:onboarding_custom_welcome]).to eq([reloaded_onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
          expect(body[:suggested_services_modal].to_json).to eq(suggested_services_modal.to_json)
        end

        context 'the user has sent a message' do
          let!(:message) { create(:message, user: user, consult: user.master_consult) }

          it "doesn't return an onboarding group" do
            expect{ do_request(email: email, password: password) }.to change(Session, :count).by(1)
            expect(response).to be_success
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:suggested_services_modal]).to be_nil
          end
        end

        context 'the user has logged in previously' do
          let!(:other_session) { create(:session, member: user) }

          it "doesn't return the onboarding_custom_welcome" do
            expect{ do_request(email: email, password: password) }.to change(Session, :count).by(1)
            expect(response).to be_success
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:onboarding_custom_welcome]).to be_empty
          end
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

  describe '#sign_up' do
    def do_request(params={})
      post '/api/v1/onboarding/sign_up', params, {"HTTP_USER_AGENT" => "test_runner"}
    end

    let!(:agreement) { create(:agreement, :active) }
    let(:email) { 'test+signup@getbetter.com' }
    let(:password) { 'password' }

    it 'creates a free user' do
      expect{ do_request(user: {email: email, password: password, agreement_id: agreement.id}) }.to change(Member, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      user = Member.find(body[:user][:id])
      expect(body[:user].to_json).to eq(user.serializer.as_json.to_json)
      expect(user).to be_free #FREEEEEDOM
    end

    it 'creates a session for the user' do
      expect{ do_request(user: {email: email, password: password, agreement_id: agreement.id}) }.to change(Session, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      user = Member.find(body[:user][:id])
      session = Session.find_by_auth_token!(body[:auth_token])
      expect(session.member).to eq(user)
    end

    context 'with (allthethings)' do
      let!(:onboarding_group) { create(:onboarding_group, custom_welcome: 'lorem ipsum') }
      let!(:onboarding_group_suggested_service_template) { create(:onboarding_group_suggested_service_template, onboarding_group: onboarding_group) }
      let!(:suggested_service_template) { onboarding_group_suggested_service_template.suggested_service_template }
      let!(:referral_code) { create(:referral_code, onboarding_group: onboarding_group, creator: nil) }
      let(:stripe_helper) { StripeMock.create_test_helper }
      let(:token) { stripe_helper.generate_card_token }
      let(:plan_id) { 'bp20' }

      before do
        StripeMock.start
        Stripe::Plan.create(amount: 1999,
                            interval: :month,
                            name: 'Single Membership',
                            currency: :usd,
                            id: plan_id)
        CarrierWave::Mount::Mounter.any_instance.stub(:store!)
        onboarding_group.update_attributes!(header_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')),
                                            background_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')))
      end

      after do
        StripeMock.stop
      end

      it 'creates a premium user and sets all the things' do
        expect{ do_request(user: {email: email, password: password, agreement_id: agreement.id, code: referral_code.code, payment_token: token}) }.to change(Member, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        user = Member.find(body[:user][:id])
        expect(body[:user].to_json).to eq(user.serializer.as_json.to_json)
        expect(user).to be_premium
        expect(user.onboarding_group).to eq(onboarding_group)
        expect(user.referral_code).to eq(referral_code)
        expect(user.suggested_services.count).to eq(1)
        expect(user.suggested_services.first.suggested_service_template).to eq(suggested_service_template)
        suggested_services_modal = {
          header_text: 'To get started with a Personal Health Assistant, please select a Service.',
          suggested_services: [user.suggested_services.first.serializer.as_json],
          action_button_text: "LET'S GO!"
        }
        expect(body[:suggested_services_modal].to_json).to eq(suggested_services_modal.to_json)
        expect(Stripe::Customer.all.count).to eq(1)
        expect(Stripe::Customer.all[0].subscriptions.count).to eq(1)
        expect(Stripe::Customer.all[0].cards.count).to eq(1)
        expect(body[:onboarding_custom_welcome]).to eq([user.onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
      end
    end
  end
end
