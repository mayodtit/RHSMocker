require 'spec_helper'

describe 'Allergies' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }

  context 'existing record' do
    let!(:allergy) { create(:allergy) }

    describe 'GET /API/v1/allergies' do
      def do_request
        get '/api/v1/allergies', auth_token: session.auth_token
      end

      it 'retuns the list of allergies' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:allergies].to_json).to eq([allergy].serializer.as_json.to_json)
      end

      context 'with synonyms' do
        let!(:synonym) { create(:allergy, master_synonym: allergy) }

        it 'filters out synonyms' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:allergies].to_json).to eq([allergy].serializer.as_json.to_json)
        end
      end

      context 'with a query parameter' do
        def do_request
          get '/api/v1/allergies', auth_token: session.auth_token, q: "A"
        end

        before do
          Api::V1::AllergiesController.any_instance.stub(:solr_results).and_return(Allergy.all)
        end

        it 'retuns the list of matching allergies' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:allergies].to_json).to eq([allergy].serializer.as_json.to_json)
        end

        context 'with synonyms' do
          let!(:synonym) { create(:allergy, master_synonym: allergy) }

          it 'filters out synonyms' do
            do_request
            expect(response).to be_success
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:allergies].to_json).to eq([allergy].serializer.as_json.to_json)
          end
        end
      end
    end
  end
end
