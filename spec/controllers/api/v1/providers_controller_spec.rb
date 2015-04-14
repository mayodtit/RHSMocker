require 'spec_helper'

describe Api::V1::ProvidersController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:provider) {
                   {
                     first_name: 'Kyle',
                     last_name: 'Chilcutt',
                     npi_number: '0123456789',
                     city: 'San Francisco',
                     state: 'CA',
                     expertise: 'Counterfeiting Medical Credentials'
                   }
                 }

  before do
    controller.stub(current_ability: ability)
    Search::Service.any_instance.stub(query: [provider])
    User.stub(find_by_npi_number: [provider])
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it_behaves_like 'success'

      it 'returns providers from the search service' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:users].to_json).to eq([provider].as_json.to_json)
      end
    end
  end

  describe 'GET search' do
    def do_request
      get :search
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it_behaves_like 'success'

      it 'returns providers from the search service' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:providers].to_json).to eq([provider].as_json.to_json)
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it_behaves_like 'success'

      it 'returns provider from the database' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:provider].to_json).to eq([provider].serializer.as_json.to_json)
      end
    end
  end
end
