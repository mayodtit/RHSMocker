require 'spec_helper'

describe 'Enrollments' do
  context 'existing record' do
    let!(:enrollment) { create(:enrollment) }

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
    end
  end

  describe 'POST /api/v1/enrollments' do
    def do_request(params={})
      post "/api/v1/enrollments", params
    end

    let(:enrollment_attributes) { attributes_for(:enrollment) }

    it 'creates a enrollment' do
      expect{ do_request(enrollment: enrollment_attributes) }.to change(Enrollment, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:enrollment].to_json).to eq(Enrollment.last.serializer.as_json.to_json)
    end
  end
end
