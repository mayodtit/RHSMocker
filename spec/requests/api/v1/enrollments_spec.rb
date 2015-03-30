require 'spec_helper'

describe 'Enrollments' do
  let!(:enrollment) { create(:enrollment) }

  describe 'GET /api/v1/enrollments/on_board' do
    let!(:unique_on_boarding_user_token){'test_uout'}
    let!(:user){create(:member, unique_on_boarding_user_token: unique_on_boarding_user_token)}
    let!(:nux_story) { create(:nux_story, enabled: true, ordinal: 1) }

    def do_request(params={})
      get "/api/v1/enrollments/on_board", params
    end

    context 'the user has a valid unique_on_boarding_user_token' do
      context 'the user is existing' do
        it 'should return the login info to the client' do
          do_request(:unique_on_boarding_user_token => unique_on_boarding_user_token)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:auth_token].to_json).not_to eq(nil)
          expect(body[:stories]).to_not be_empty
        end
      end

      context 'the user is not existing' do
        let!(:enrollment){create(:enrollment, unique_on_boarding_user_token: unique_on_boarding_user_token)}

        before do
          user.destroy
        end

        it 'should populate user info, and render sign on stories' do
          do_request(:unique_on_boarding_user_token => unique_on_boarding_user_token)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:stories]).to_not be_empty
        end
      end
    end

    context 'the user has a invalid unique_on_boarding_user_token' do
      let!(:wrong_token){'wrong_uout'}

      it 'should render error message to client' do
        do_request(:unique_on_boarding_user_token => wrong_token)
        expect(response).not_to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:reason]).to eq('invalid uout')
      end
    end

    context 'the user dont have a unique_on_boarding_user_token' do
      it 'should render error message to client' do
        do_request
        expect(response).not_to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:reason]).to eq('invalid uout')
      end
    end
  end

  describe 'GET /api/v1/enrollments/:id' do
    def do_request
      get "/api/v1/enrollments/#{enrollment.token}"
    end

    it 'shows the enrollment' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:enrollment].to_json).to eq(enrollment.serializer.as_json.to_json)
    end
  end

  describe 'PUT /api/v1/enrollments/:id' do
    def do_request(params={})
      put "/api/v1/enrollments/#{enrollment.token}", params
    end

    let(:new_email) { 'kyle+test@getbetter.com' }

    it 'updates the enrollment' do
      do_request(enrollment: {email: new_email})
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(enrollment.reload.email).to eq(new_email)
      expect(body[:enrollment].to_json).to eq(enrollment.serializer.as_json.to_json)
    end

    context 'with a onboarding group that has skip_credit_card' do
      let!(:nux_story) { create(:nux_story, unique_id: 'CREDIT_CARD', enabled: true) }
      let!(:onboarding_group) { create(:onboarding_group, :premium, skip_credit_card: true) }
      let!(:referral_code) { create(:referral_code, onboarding_group: onboarding_group) }

      it "changes the NuxStory enabled attribute to false" do
        NuxStory.credit_card.enabled.should be_true
        do_request(enrollment: {email: new_email, code: referral_code.code})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:credit_card_story][:enabled]).to be_false
      end
    end

    context 'referral code is not invalid' do
      it 'returns error message' do
        do_request(enrollment: {email: new_email, code: 'insider'})
        response.should_not be_success
        JSON.parse(response.body)['reason'].should == "invalid referral code"
        JSON.parse(response.body)['user_message'].should == "Referral code is invalid"
      end
    end

    context 'with a referral code when sign up' do
      let(:new_email) { 'kyle+test@getbetter.com' }
      let(:member) {create(:member)}
      let!(:onboarding_group) { create(:onboarding_group, :premium, skip_credit_card: false) }
      let!(:nux_story) { create(:nux_story, unique_id: 'REFER', enabled: true) }
      let!(:referral_code) { create(:referral_code, onboarding_group: onboarding_group, user_id: member.id) }

      it "renders different story if user uses others' referral code" do
        do_request(enrollment: {email: new_email, code: referral_code.code})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:trial_story][:unique_id]).to eq('REFER')
      end
    end
  end

  describe 'POST /api/v1/enrollments' do
    def do_request(params={})
      post "/api/v1/enrollments", params
    end

    context 'for business onboading group' do
      let(:enrollment_attributes) { {:business_on_board => 'yes', :first_name => 'first_name', :last_name => 'last_name', :email => 'email@gmail.com'} }

      it 'creates an enrollment, set the uuot, and send out invitation email' do
        Rails.stub(env: ActiveSupport::StringInquirer.new("development"))
        do_request(enrollment: enrollment_attributes)
        expect(response).to be_success
        expect(Delayed::Job.count).to eq(1)
      end
    end


    context 'for normal users' do
      let(:enrollment_attributes) { {:first_name => 'first_name', :last_name => 'last_name', :email => 'email@gmail.com'} }

      it 'creates a enrollment' do
        expect{ do_request(enrollment: enrollment_attributes) }.to change(Enrollment, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:enrollment].to_json).to eq(Enrollment.last.serializer.as_json.to_json)
      end
    end
  end
end
