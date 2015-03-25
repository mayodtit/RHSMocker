require 'spec_helper'
require 'stripe_mock'

shared_examples 'creates a member' do
  it 'creates a new member and returns member and auth_token' do
    expect{ do_request(member_params) }.to change(Member, :count).by(1)
    expect(response).to be_success
    body = JSON.parse(response.body, symbolize_names: true)
    member = Member.find(body[:user][:id])
    expect(body[:auth_token]).to eq(member.sessions.first.auth_token)
  end
end

describe 'Members' do
  context 'with existing record' do
    let!(:member) { create(:admin) }
    let(:session) { member.sessions.create }

    describe 'GET /api/v1/members' do
      def do_request(params={})
        get '/api/v1/members', {auth_token: session.auth_token}.merge!(params)
      end

      it 'indexes all Members' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, symbolize_names: true)
        ids = body[:users].map{|c| c[:id]}
        ids.should include(member.id)
      end

      context 'with a query param' do
        let!(:other_member) { create(:member) }

        it 'filters Members with param' do
          do_request(q: member.email)
          response.should be_success
          body = JSON.parse(response.body, symbolize_names: true)
          ids = body[:users].map{|c| c[:id]}
          ids.should include(member.id)
          ids.should_not include(other_member.id)
        end
      end

      context 'with pha id' do
        let!(:pha) { create(:pha) }
        let!(:other_member) { create(:member, pha_id: member.id ) }
        let!(:another_member) { create(:member, pha_id: member.id ) }
        let!(:yet_another_member) { create(:member, pha_id: pha.id ) }

        it 'filters Members with param' do
          do_request(q: 'test.com', pha_id: member.id)
          response.should be_success
          body = JSON.parse(response.body, symbolize_names: true)
          ids = body[:users].map{|c| c[:id]}
          ids.should include(other_member.id)
          ids.should include(another_member.id)
          ids.should_not include(member.id)
          ids.should_not include(yet_another_member.id)
          ids.should_not include(pha.id)
        end
      end
    end
  end

  describe 'POST /api/v1/members' do
    def do_request(params={})
      post '/api/v1/members', params
    end

    let(:stripe_helper) { StripeMock.create_test_helper }
    let(:enrollment) { create(:enrollment) }
    let(:credit_card_token) { stripe_helper.generate_card_token }
    let(:plan_id) { 'bp20' }
    let(:member_params) { {user: {email: 'kyle+test@getbetter.com', password: 'password', enrollment_token: enrollment.token, payment_token: credit_card_token}} }

    before do
      StripeMock.start
      Stripe::Plan.create(amount: 1999,
                          interval: :month,
                          name: 'Single Membership',
                          currency: :usd,
                          id: plan_id)
    end

    after do
      StripeMock.stop
    end

    it_behaves_like 'creates a member'

    it 'saves an enrollment when present' do
      expect{ do_request(member_params) }.to change(Member, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      member = Member.find(body[:user][:id])
      expect(body[:user][:id]).to eq(member.id)
      expect(body[:auth_token]).to eq(member.sessions.first.auth_token)
      expect(enrollment.reload.user).to eq(member)
    end

    context 'business on boarding' do
      let(:member_params) { {user: {email: 'kyle+test@getbetter.com', password: 'password', business_on_board: "yes"}} }

      it 'should send out invite email' do
        Rails.stub(env: ActiveSupport::StringInquirer.new("development"))
        do_request(member_params)
        expect(response).to be_success
        expect(Delayed::Job.count).to eq(1)
      end
    end

    context 'with a referral code' do
      let(:referrer) { create(:member) }
      let(:referral_code) { create(:referral_code, :with_onboarding_group, user: referrer) }
      let(:member_params) { {user: {email: 'kyle+test@getbetter.com', password: 'password', enrollment_token: enrollment.token, payment_token: credit_card_token, code: referral_code.code}} }

      it 'queues an email to the referrer' do
        NotifyReferrerWhenRefereeSignUpService.should_receive(:new).once.and_call_original
        do_request(member_params)
      end
    end

    context 'Mayo Pilot 2' do
      let!(:service_type) { create(:service_type, name: 'other engagement') }
      let!(:onboarding_group) { create(:onboarding_group, premium: true, name: 'Mayo Pilot 2') }
      let!(:referral_code) { create(:referral_code, onboarding_group: onboarding_group) }
      let(:member_params) { {user: {email: 'kyle+test@getbetter.com', password: 'password', enrollment_token: enrollment.token, payment_token: credit_card_token, code: referral_code.code}} }

      it 'creates a task for the PHA' do
        expect{ do_request(member_params) }.to change(MemberTask, :count).by(1)
      end
    end
  end
end
