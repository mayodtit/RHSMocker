require 'spec_helper'
require 'stripe_mock'

describe SignUpService do
  before do
    StripeMock.start
  end

  after do
    StripeMock.stop
  end

  let!(:stripe_helper) { StripeMock.create_test_helper }
  let!(:stripe_plan) { stripe_helper.create_plan(id: 'bp20') }
  let!(:stripe_card_token) { stripe_helper.generate_card_token }
  let!(:stripe_coupon) { Stripe::Coupon.create(id: 'discount', percent_off: 50, duration: 'once') }

  let(:email) { 'test@getbetter.com' }
  let(:first_name) { 'Kyle' }
  let(:last_name) { 'Chilcutt' }
  let(:referring_user) { create(:member, :premium) }
  let!(:onboarding_group) { create(:onboarding_group, premium: true, stripe_coupon_code: stripe_coupon.id) }
  let!(:referral_code) { create(:referral_code, onboarding_group: onboarding_group, user: referring_user) }
  let!(:enrollment) do
    create(:enrollment, onboarding_group: onboarding_group,
                        referral_code: referral_code,
                        email: email,
                        first_name: first_name,
                        last_name: last_name)
  end

  let!(:other_engagement_service_type) { create(:service_type, name: 'other engagement') }

  describe '#call' do
    context 'sucessfully doing EVERYTHING' do
      let(:params) do
        {
          user: {
            email: 'test@getbetter.com',
            password: 'password',
            onboarding_group: onboarding_group,
            referral_code: referral_code,
            enrollment: enrollment
          },
          subscription: {
            payment_token: stripe_card_token,
            coupon_code: stripe_coupon
          }
        }
      end
      let(:options) do
        {
          send_download_link: true,
          mayo_pilot_2: true
        }
      end

      it 'returns success' do
        response = described_class.new(params, options).call
        expect(response[:success]).to be_true
      end

      describe 'member creation' do
        it 'creates the member' do
          expect{ described_class.new(params, options).call }.to change(Member, :count).by(1)
        end

        it 'creates a member with the expected attributes' do
          response = described_class.new(params, options).call
          user = response[:user]
          expect(user).to be_a(Member)
          expect(user.email).to eq('test@getbetter.com')
          expect(user.premium?).to be_true
        end
      end

      it 'creates a session for the member' do
        expect{ described_class.new(params, options).call }.to change(Session, :count).by(1)
      end

      describe 'subscription creation' do
        it 'creates a Stripe customer for the member' do
          response = described_class.new(params, options).call
          user = response[:user]
          expect(user.stripe_customer_id).to be_present
          expect(Stripe::Customer.retrieve(user.stripe_customer_id)).to be_present
        end

        it 'creates a Stripe subscription for the member' do
          response = described_class.new(params, options).call
          user = response[:user]
          customer = Stripe::Customer.retrieve(user.stripe_customer_id)
          expect(customer.subscriptions.count).to eq(1)
          expect(customer.subscriptions.first.plan.id).to eq(stripe_plan.id)
        end

        it 'creates a default card for the user' do
          response = described_class.new(params, options).call
          user = response[:user]
          customer = Stripe::Customer.retrieve(user.stripe_customer_id)
          expect(customer.cards.count).to eq(1)
        end

        it 'applys a coupon when present' do
          response = described_class.new(params, options).call
          user = response[:user]
          customer = Stripe::Customer.retrieve(user.stripe_customer_id)
          expect(customer.coupon).to_not be_empty
        end
      end

      describe 'calling other services' do
        let(:send_welcome_email_service) { double('welcome', call: true) }
        let(:send_email_confirmation_service) { double('confirm', call: true) }
        let(:send_download_link_service) { double('sms', call: true) }
        let(:send_email_to_stakeholders_service) { double('stakeholders', call: true) }
        let(:notify_referrer_when_referee_sign_up_service) { double('referral', call: true) }

        it 'sends the welcome email' do
          SendWelcomeEmailService.stub(new: send_welcome_email_service)
          send_welcome_email_service.should_receive(:call).once
          described_class.new(params, options).call
        end

        it 'sends the email confirmation email' do
          SendConfirmEmailService.stub(new: send_email_confirmation_service)
          send_email_confirmation_service.should_receive(:call).once
          described_class.new(params, options).call
        end

        it 'sends SMS download link' do
          SendDownloadLinkService.stub(new: send_download_link_service)
          send_download_link_service.should_receive(:call).once
          described_class.new(params, options).call
        end

        it 'notifies stakeholders' do
          SendEmailToStakeholdersService.stub(new: send_email_to_stakeholders_service)
          send_email_to_stakeholders_service.should_receive(:call).once
          described_class.new(params, options).call
        end

        it 'notifies referrer' do
          NotifyReferrerWhenRefereeSignUpService.stub(new: notify_referrer_when_referee_sign_up_service)
          notify_referrer_when_referee_sign_up_service.should_receive(:call).once
          described_class.new(params, options).call
        end
      end

      describe 'other random bullshit' do
        it 'creates a Mayo Pilot 2 task' do
          response = described_class.new(params, options).call
          user = response[:user]
          expect(user.tasks.where(title: 'Discharge Instructions Follow Up').count).to eq(1)
        end
      end
    end

    context 'member is invalid' do
      let(:params) do
        {
          user: {
            email: 'whatever',
            password: 'password',
            onboarding_group: onboarding_group,
            referral_code: referral_code,
            enrollment: enrollment
          },
          subscription: {
            payment_token: stripe_card_token,
            coupon_code: stripe_coupon
          }
        }
      end

      it 'returns failure' do
        response = described_class.new(params).call
        expect(response[:success]).to be_false
      end

      it 'sets the reason properly' do
        response = described_class.new(params).call
        expect(response[:reason]).to eq('Email is invalid')
      end
    end

    context 'subscription fails' do
      let(:params) do
        {
          user: {
            email: 'test@getbetter.com',
            password: 'password',
            onboarding_group: onboarding_group,
            referral_code: referral_code,
            enrollment: enrollment
          },
          subscription: {
            payment_token: stripe_card_token,
            coupon_code: stripe_coupon
          }
        }
      end

      context 'with card error' do
        before do
          StripeMock.prepare_card_error(:card_declined, :new_customer)
        end

        it 'returns failure' do
          response = described_class.new(params).call
          expect(response[:success]).to be_false
        end

        it 'returns card error string' do
          response = described_class.new(params).call
          expect(response[:reason]).to eq('The card was declined')
        end
      end

      context 'with a different error' do
        before do
          StripeMock.prepare_error(Stripe::StripeError, :new_customer)
        end

        it 'returns failure' do
          response = described_class.new(params).call
          expect(response[:success]).to be_false
        end

        it 'returns error string' do
          response = described_class.new(params).call
          expect(response[:reason]).to eq("There's an error with your credit card, please try another one")
        end
      end
    end
  end
end
