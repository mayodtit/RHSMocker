require 'spec_helper'

describe 'Enrollments' do
  context 'existing record' do
    let!(:enrollment) { create(:enrollment) }

    describe 'GET /api/v1/enrollments/on_board/uout' do
      let!(:enrollment_with_uout){create(:enrollment, uout: 'test_uout')}

      context 'the user has a valid uout' do
        let(:uout){'test_uout'}
        context 'the valid uout has not been used' do

        end

        context 'the valid uout has been used' do
          let(:user){create(:member)}
          before do
            :enrollment_with_uout.update_attributes(:used_uout => true)
          end

          it 'should return the login info to the client' do

          end
        end
      end

      context 'the user has a invalid uout, or not have a uout' do

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
  end

  describe 'POST /api/v1/enrollments' do
    def do_request(params={})
      post "/api/v1/enrollments", params
    end

    context 'for business onboading group' do
      let(:enrollment_attributes) { {:business_on_board => 'yes', :first_name => 'first_name', :last_name => 'last_name', :email => 'email@gmail.com'} }

      it 'creates an enrollment, set the uuot, and send out invitation email' do
        Rails.stub(env: ActiveSupport::StringInquirer.new("development"))
        byebug
        do_request(enrollment: enrollment_attributes)
        expect(response).to be_success
        expect(Delayed::Job.count).to eq(1)
      end
    end


    context 'for normal users' do
      let(:enrollment_attributes) { attributes_for(:enrollment) }

      it 'creates a enrollment' do
        expect{ do_request(enrollment: enrollment_attributes) }.to change(Enrollment, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:enrollment].to_json).to eq(Enrollment.last.serializer.as_json.to_json)
      end
    end
  end
end
